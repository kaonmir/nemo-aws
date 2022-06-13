# Argocd
# 지금은 defulat 값이 ID: admin, PW: admin1234 이다.
ARGOCD_PW=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
echo "Argocd is running, initial id='admin' and pw is='$ARGOCD_PW' unless you changed"

# Grafana
# Dashboard: 11074
GRAFANA_ID=$(kubectl get secret grafana -n istio-system -o jsonpath='{.data.admin-user}' | base64 -d)
GRAFANA_PW=$(kubectl get secret grafana -n istio-system -o jsonpath='{.data.admin-password}' | base64 -d)
echo "ID: $GRAFANA_ID, PW: $GRAFANA_PW"

# Istio
ISTIO_HOSTNAME=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Istio ingress is running on host \"$ISTIO_HOSTNAME\""

# Kiali
KIALI_TOKEN_NAME=$(kubectl get sa kiali-service-account -n istio-system -o jsonpath="{.secrets[0].name}")
KIALI_TOKEN=$(kubectl get secret -n istio-system $KIALI_TOKEN_NAME -o jsonpath="{.data.token}" | base64 -d)
echo "Kiali is running with token $KIALI_TOKEN"

# Kiali validator
# bash <(curl -sL https://raw.githubusercontent.com/kiali/kiali-operator/master/crd-docs/bin/validate-kiali-cr.sh) \
#   -crd https://raw.githubusercontent.com/kiali/kiali-operator/master/crd-docs/crd/kiali.io_kialis.yaml \
#   --kiali-cr-name kiali \
#   -n istio-system

# Istio Validator
# istioctl analyze --all-namespaces