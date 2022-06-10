#!/bin/bash

# TODO: admin node에서 daemonset 빼기

BASEDIR=$(dirname $0)

# namespaces
kubectl create namespace istio-system
kubectl create namespace cert-manager

# cert-manager
helm repo add jetstack https://charts.jetstack.io
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager -n cert-manager -f $BASEDIR/values/cert-manager.yaml --version v1.7.1

# metric-server (for HPA, VPA and "kubectl top")
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  
# Argocd 
kubectl create namespace argocd
helm repo add argocd https://argoproj.github.io/argo-helm
helm install argocd argocd/argo-cd -n argocd -f $BASEDIR/values/argocd.yaml

# Prometheus
helm repo add prometheus https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus/prometheus -n istio-system -f $BASEDIR/values/prometheus.yaml

# Grafana & Grafana Loki
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana -n istio-system -f $BASEDIR/values/grafana.yaml
# helm install loki grafana/loki -n istio-system -f values/loki.yaml

# Fluent Bit
helm repo add fluent https://fluent.github.io/helm-charts
helm install fluent-bit fluent/fluent-bit -n istio-system -f $BASEDIR/values/fluent-bit.yaml


#- Extracing crucial data -#

## Legacy

# Installl CloudWatch agent and Fluentd. So the logs and metrics are sent to CloudWatch
# FluentBitHttpPort='2020'
# FluentBitReadFromHead='Off'
# [[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
# [[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
# curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${CLUSTER_NAME}'/;s/{{region_name}}/'${REGION_NAME}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -
# aws iam attach-role-policy --role-name eks_node --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

# Kiali
# helm repo add kiali https://kiali.org/helm-charts
# helm install kiali kiali/kiali-server -n istio-system -f values/kiali.yaml

# Jaeger
# helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
# helm install jaeger jaegertracing/jaeger -n istio-system -f values/jaeger.yaml

# Istiod
# kubectl create namespace istio-system
# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm install base istio/base -n istio-system
# helm install istiod istio/istiod -n istio-system -f values/istiod.yaml
# helm install istio-gateway istio/gateway -n istio-system -f values/istio-gateway.yaml