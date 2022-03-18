#!/bin/bash

# Calico
helm repo add projectcalico https://docs.projectcalico.org/charts
helm install calico projectcalico/tigera-operator --version v3.21.4

# Istiod
kubectl create namespace istio-system
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm install base istio/base -n istio-system
helm install istiod istio/istiod -n istio-system -f values/istiod.yaml
helm install istio-gateway istio/gateway -n istio-system -f values/istio-gateway.yaml

# Argocd 
kubectl create namespace argocd
helm repo add argocd https://argoproj.github.io/argo-helm
helm install argocd argocd/argo-cd -n argocd -f values/argocd.yaml

# Kiali
helm repo add kiali https://kiali.org/helm-charts
helm install kiali kiali/kiali-server -n istio-system -f values/kiali.yaml

# Jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm install jaeger jaegertracing/jaeger -n istio-system -f values/jaeger.yaml


# Prometheus & Grafana
helm repo add prometheus https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus/prometheus -n istio-system -f values/prometheus.yaml
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana -n istio-system -f values/grafana.yaml

# cert-manager
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager -n cert-manager -f values/cert-manager.yaml --version v1.7.1


kubectl label namespace default istio-injection=enabled

# TODO And make multiple gateways for each admin, and business apps

# IStio
ISTIO_HOSTNAME=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Istio ingress is running on host \"$ISTIO_HOSTNAME\""

# Argocd
ARGOCD_PW=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
echo "Argocd is running, initial id='admin' and pw is='$ARGOCD_PW' unless you changed"

# Kiali
KIALI_TOKEN_NAME=$(kubectl get sa kiali-service-account -n istio-system -o jsonpath="{.secrets[0].name}")
KIALI_TOKEN=$(kubectl get secret -n istio-system $KIALI_TOKEN_NAME -o jsonpath="{.data.token}" | base64 -d)
echo "Kiali is running with token $KIALI_TOKEN"

# Grafana
GRAFANA_ID=$(k get secret grafana -n istio-system -o jsonpath='{.data.admin-user}' | base64 -d)
GRAFANA_PW=$(k get secret grafana -n istio-system -o jsonpath='{.data.admin-password}' | base64 -d)
echo "ID: $GRAFANA_ID, PW: $GRAFANA_PW"


## Legacy
# Installl CloudWatch agent and Fluentd. So the logs and metrics are sent to CloudWatch
# FluentBitHttpPort='2020'
# FluentBitReadFromHead='Off'
# [[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
# [[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
# curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${CLUSTER_NAME}'/;s/{{region_name}}/'${REGION_NAME}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -
# aws iam attach-role-policy --role-name nemo_eks_node --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
