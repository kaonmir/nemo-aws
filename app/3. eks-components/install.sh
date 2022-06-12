#!/bin/bash

BASEDIR=`dirname $0`

# TODO: admin node에서 daemonset 빼기
# namespaces
kubectl create namespace istio-system
kubectl create namespace cert-manager

# cert-manager
helm repo add jetstack https://charts.jetstack.io
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager -n cert-manager -f $BASEDIR/values/cert-manager.yaml --version v1.7.1

# metric-server (for HPA, VPA and "kubectl top")
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# -- Operator -- 
# Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your cluster.
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.20.0/install.sh | bash -s v0.20.0

# "Argocd", "Prometheus", "Grafana" will be installed by Helm
# Create namespace where the operators will be installed
kubectl create namespace observability

# Calico
# https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/calico.html
helm repo add projectcalico https://docs.projectcalico.org/charts
helm install calico projectcalico/tigera-operator --version v3.21.4

# Istio
kubectl create namespace istio-system
kubectl label namespace default istio-injection=enabled --overwrite
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm install istio-base istio/base -n istio-system
istioctl operator init

# Jaeger
kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.34.1/jaeger-operator.yaml -n observability

# Kiali
helm repo add kiali https://kiali.org/helm-charts
helm install kiali-operator kiali/kiali-operator -n observability \
  --set cr.create="true" \
  --set cr.namespace="istio-system"
    
# --Helm--
# Fluent Bit
helm repo add fluent https://fluent.github.io/helm-charts
helm install fluent-bit fluent/fluent-bit -n istio-system -f $BASEDIR/values/fluent-bit.yaml

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
# helm install loki grafana/loki -n istio-system -f $BASEDIR/values/loki.yaml

