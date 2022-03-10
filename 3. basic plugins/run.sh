# Install Istiod, IngressGateway to EKS cluster
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
ISTIO_HOSTNAME=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Install Argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
ARGOCD_PW=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)

echo "Istio ingress is running on host \"$ISTIO_HOSTNAME\""
echo "Argocd is running, initial id='admin' and pw is='$ARGOCD_PW'"