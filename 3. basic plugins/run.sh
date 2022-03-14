#!/bin/bash

# Istiod
kubectl create namespace istio-system
kubectl create namespace istio-ingress
kubectl annotate namespace istio-ingress istio-injection=enabled --overwrite 
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm install base istio/base -n istio-system
helm install istiod istio/istiod -n istio-system
helm install istio-gateway istio/gateway -n istio-system -f values/istio-gateway.yaml

# Argocd 
kubectl create namespace argocd
helm repo add argocd https://argoproj.github.io/argo-helm
helm install argocd argocd/argo-cd -n argocd -f values/argocd.yaml

# Kiali
helm repo add kiali https://kiali.org/helm-charts
helm install kiali kiali/kiali-server -n istio-system -f values/kiali.yaml


kubectl label namespace default istio-injection=enabled

# TODO And make multiple gateways for each admin, and business apps

ISTIO_HOSTNAME=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Istio ingress is running on host \"$ISTIO_HOSTNAME\""

ARGOCD_PW=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
echo "Argocd is running, initial id='admin' and pw is='$ARGOCD_PW'"


## Legacy
# Installl CloudWatch agent and Fluentd. So the logs and metrics are sent to CloudWatch
# FluentBitHttpPort='2020'
# FluentBitReadFromHead='Off'
# [[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
# [[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
# curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${CLUSTER_NAME}'/;s/{{region_name}}/'${REGION_NAME}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -
# aws iam attach-role-policy --role-name nemo_eks_node --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
