# Install Istiod, IngressGateway to EKS cluster
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
ISTIO_HOSTNAME=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo Istio ingress is running on host \"$ISTIO_HOSTNAME\""
