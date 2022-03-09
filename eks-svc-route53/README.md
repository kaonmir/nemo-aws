If you want to set Route53 automatically, set like underneath

``` yaml
annotations:
  external-dns.alpha.kubernetes.io/hostname: yourservice.external-dns-test.my-org.com
```