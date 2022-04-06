## Nemo AWS Architecture

To switch ingress gateway load balancer to ALB, add this annotation to Ingress gateway services



``` yaml
annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
    
```
