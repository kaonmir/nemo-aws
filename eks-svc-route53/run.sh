#!/bin/bash

# apply terraform infra to AWS
cd terraform
terraform init
terraform apply --auto-approve
cd ..

# Apply Kubernetes yaml file
kubectl apply -f k8s.yaml

CURRENT_PATH=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
CLUSTER_NAME=terraform-eks

# Create Role to make role available to be attached to EKS cluster
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_PROVIDER=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

read -r -d '' TRUST_RELATIONSHIP <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:aud": "sts.amazonaws.com",
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:kube-system:external-dns"
        }
      }
    }
  ]
}
EOF

# Attach IAM Role to EKS Cluster
POLICY_ARN=$(terraform output -json --state=$CURRENT_PATH/terraform/terraform.tfstate | jq '."policy-arn".value' | tr -d '"')
ROLE_NAME=EKSServiceRoute53Role

aws iam create-role \
--role-name $ROLE_NAME \
--assume-role-policy-document "$TRUST_RELATIONSHIP" \
--description "role for associating EKS service and Route53 with annotation"

aws iam attach-role-policy \
--role-name $ROLE_NAME \
--policy-arn $POLICY_ARN