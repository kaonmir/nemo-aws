[reference](https://velog.io/@airoasis/EKS-%EC%97%90%EC%84%9C-Istio-%EC%99%80-ALB-%EC%97%B0%EA%B2%B0)

EKS에서 ALB를 사용하는 법을 적는다.

EKS에서 service에 Load balancer 타입을 적용하면 AWS ELB가 생성되는데, 이게 Class Load Balancer로 생성된다.

AWS의 시작과 함께 있었던 CLB인 만큼 왠지 쓰기 찝찝하다. 수 틀리면 deprecated 될 수도 있단 그런 느낌이랄까..? 그래서 NLB나 ALB를 쓰고 싶어서 방법을 찾아봤다.

일단 NLB 적용은 굉장히 간단하다. 