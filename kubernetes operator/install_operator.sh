# Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your cluster.
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.20.0/install.sh | bash -s v0.20.0

kubectl apply -f https://operatorhub.io/install/prometheus.yaml
kubectl apply -f https://operatorhub.io/install/istio.yaml
# kubectl apply -f https://operatorhub.io/install/grafana-operator.yaml

helm install grafana-operator bitnami/grafana-operator -n operators 


# Jaeger
kubectl create namespace observability
kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.32.0/jaeger-operator.yaml -n observability

# Kiali
kubectl create namespace operators
helm repo add kiali https://kiali.org/helm-charts
helm install --set cr.create=true \
    --set cr.namespace=istio-system \
    --namespace operators \
    --create-namespace \
    kiali-operator \
    kiali/kiali-operator

# Kiali validator
bash <(curl -sL https://raw.githubusercontent.com/kiali/kiali-operator/master/crd-docs/bin/validate-kiali-cr.sh) \
  -crd https://raw.githubusercontent.com/kiali/kiali-operator/master/crd-docs/crd/kiali.io_kialis.yaml \
  --kiali-cr-name kiali \
  -n istio-system