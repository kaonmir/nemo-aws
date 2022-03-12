In this folder, we are going to install some essential plugins

* Argocd
* Istio (Istiod, IngressGateway, EgressGateway)

### Istio

By Default, `default` namespace is enabled to istio-injection.
If you want more namespaces to be enabled, use this command.

`kubectl label namespace <namespace> istio-injection=enabled`

And after the ingress loadbalancer is created, you should modify the security group for EKS nodegorup which is prohibiting 80, 433 ports.
Set security group to allow traffics HTTP(80) and HTTPS(80) from ingress loadbalancer.

### Argocd

New argocd admin account is defined by default. ID is `admin` and PW is shown by under commmand.

`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

If you want to change admin password as default, use this command
