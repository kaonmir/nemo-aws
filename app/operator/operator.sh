# Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your cluster.
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.20.0/install.sh | bash -s v0.20.0

# "Argocd", "Prometheus", "Grafana" will be installed by Helm

# Create namespace where the operators will be installed
kubectl create namespace observability

# Calico
helm repo add projectcalico https://docs.projectcalico.org/charts
helm install calico projectcalico/tigera-operator --version v3.21.4

# Istio
kubectl create namespace istio-system
istioctl operator init

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

# Istio Validator
istioctl analyze --all-namespaces