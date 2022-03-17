# Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your cluster.
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.20.0/install.sh | bash -s v0.20.0

# Argocd will be installed by Helm

kubectl apply -f https://operatorhub.io/install/prometheus.yaml
# kubectl apply -f https://operatorhub.io/install/grafana-operator.yaml

helm install grafana-operator bitnami/grafana-operator -n observability 

# Create namespace where the operators will be iinstalled
kubectl create namespace observability

# Istio
kubectl create namespace istio-system
wget https://github.com/istio/istio/releases/download/1.13.2/istio-1.13.2-osx-arm64.tar.gz
tar -xzf istio-1.13.2-osx-arm64.tar.gz
helm install istio-operator istio-1.13.2/manifests/charts/istio-operator -n observability \
  --set operatorNamespace="observability" \
  --set watchedNamespaces="istio-system"

rm -rf istio-1.13.2-osx-arm64.tar.gz istio-1.13.2

# Jaeger
kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.32.0/jaeger-operator.yaml -n observability

# Kiali
helm repo add kiali https://kiali.org/helm-charts
helm install kiali-operator kiali/kiali-operator -n observability
  --set cr.create="true" \
  --set cr.namespace="istio-system"
    

# Kiali validator
bash <(curl -sL https://raw.githubusercontent.com/kiali/kiali-operator/master/crd-docs/bin/validate-kiali-cr.sh) \
  -crd https://raw.githubusercontent.com/kiali/kiali-operator/master/crd-docs/crd/kiali.io_kialis.yaml \
  --kiali-cr-name kiali \
  -n istio-system