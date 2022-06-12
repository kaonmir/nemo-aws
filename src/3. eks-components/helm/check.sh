# Argocd
# 지금은 defulat 값이 ID: admin, PW: admin1234 이다.
ARGOCD_PW=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
echo "Argocd is running, initial id='admin' and pw is='$ARGOCD_PW' unless you changed"

# Grafana
# Dashboard: 11074
GRAFANA_ID=$(kubectl get secret grafana -n istio-system -o jsonpath='{.data.admin-user}' | base64 -d)
GRAFANA_PW=$(kubectl get secret grafana -n istio-system -o jsonpath='{.data.admin-password}' | base64 -d)
echo "ID: $GRAFANA_ID, PW: $GRAFANA_PW"

 