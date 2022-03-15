If you want to set Route53 automatically, set like underneath

``` yaml
annotations:
  external-dns.alpha.kubernetes.io/hostname: yourservice.external-dns-test.my-org.com
```

### Route53 Hosted Zone

Now new hosted zone is created as a subdomain. So you are supposed to set a new NS record on root domain for redirecting DNS traffic to hosted zone we created.

If you have an error on "external-dns", then install istio on the cluster in advance

And You have to create route53 in advance