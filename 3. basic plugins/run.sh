#!/bin/bash

CLUSTER_NAME=nemo
REGION_NAME=ap-northeast-2
API_SERVER=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.endpoint" --output text)

# Install Istiod, IngressGateway to EKS cluster
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
ISTIO_HOSTNAME=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Istio ingress is running on host \"$ISTIO_HOSTNAME\""

# Installl CloudWatch agent and Fluentd. So the logs and metrics are sent to CloudWatch
FluentBitHttpPort='2020'
FluentBitReadFromHead='Off'
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${CLUSTER_NAME}'/;s/{{region_name}}/'${REGION_NAME}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -


# Install Argocd using helm
kubectl create ns argocd
helm repo add argocd https://argoproj.github.io/argo-helm
helm install argocd -n argocd argocd/argo-cd -f argocd_values.yaml \
    --kube-apiserver "$API_SERVER" \
    --kubeconfig "$HOME/.kube/config" \
    --namespace "argocd"
    
ARGOCD_PW=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
echo "Argocd is running, initial id='admin' and pw is='$ARGOCD_PW'"