aws
terraform
kubectl
istioctl
argocd


istio => argocd

# install istioctl
curl -sL https://istio.io/downloadIstioctl | sh -
cp $HOME/.istioctl/bin/istioctl /usr/local/bin/istioctl
rm -rf $HOME/.istioctl

istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled