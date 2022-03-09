### Istio

By Default, `default` namespace is enabled to istio-injection.
If you want more namespaces to be enabled, use this command.

`kubectl label namespace <namespace> istio-injection=enabled`

### Argocd

New argocd admin account is defined by default. ID is `admin` and PW is shown by under commmand.

`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`


- [ ] make kube config file from EKS cluster