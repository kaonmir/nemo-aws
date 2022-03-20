EKS에서 ALB를 사용하는 법을 적는다.

EKS에서 service에 Load balancer 타입을 적용하면 AWS ELB가 생성되는데, 이게 Class Load Balancer로 생성된다.

AWS의 시작과 함께 있었던 CLB인 만큼 왠지 쓰기 찝찝하다. 수 틀리면 deprecated 될 수도 있단 그런 느낌이랄까..? 그래서 NLB나 ALB를 쓰고 싶어서 방법을 찾아봤다.

일단 NLB 적용은 굉장히 간단하다. Istio Annotation에 `service.beta.kubernetes.io/aws-load-balancer-type: "nlb"`만 적어주면 자동으로 CLB에서 NLB로 바뀐다.

하지만 ALB 적용은 좀 복잡하다. L7 로드밸런서라서 그런가, 따로 controller도 설치해줘야 하고 복잡하다. 지금 든 생각인데 Nginx Ingress Controller 적용하는 것과 똑같다!

어쨌든 `aws-load-balancer-controller`를 설치하고 ingressClassName을 alb로 설정한 ingress를 만들면 된다. 나의 경우에는 처음에 아래 에러가 났었다.

### 에러 & 해결

> couldn't auto-discover subnets: unable to discover at least one subnet

이 문제는 ingress controller에 `ec2:DescribeAvailabilityZones` policy가 붙어 있지 않거나, subnet에 태그가 적용이 안되었기 때문이란다.

전자는 확실히 아니고 (terraform으로 생성된 거 몇 번이나 확인함), 나는 후자가 분명하다. Private subnet에는 `kubernetes.io/role/internal-elb: 1`, public subnet에는 `kubernetes.io/role/elb: 1`을 붙여주면 된다. 적용하고 pod 한 번 지우니까 잘 된다!

이 태그는 폴더 내에서는 적용이 불가능하고 그냥 `1. eks-cluster` 폴더의 terraform에 박아버릴 것이다. 나중에 ALB를 적용할 때에는 자동으로 적용되어 있으니 신경 쓸 필요가 없을 거다.

### Reference

[reference](https://velog.io/@airoasis/EKS-%EC%97%90%EC%84%9C-Istio-%EC%99%80-ALB-%EC%97%B0%EA%B2%B0), 좋은 레퍼런스긴 한데 Ingress가 옛날 거라서 바꿔줘야 한다.
