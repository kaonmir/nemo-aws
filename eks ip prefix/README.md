EKS에는 워커 노드별로 할당할 수 있는 최대 팟 개수가 있다.
너무 불편하고 deployment를 배포하는 거야 다른 노드에 배포하면 되니 상관없지만, daemonset의 경우는 상관이 있다.
가득 찬 노드에도 무조건 팟을 생성해야 하니, daemonset은 pending 상태에서 머무를 수 밖에 없고, 어플리케이션은 영원히 실행되지 않는다.

이에 대한 가장 원초적인 해결 방법은 가득 찬 노드를 삭제하는 것이다.
그러면 이미 설치해놓은 Cluster Autoscaling이 새로운 노드를 만들어 주기 때문에 깔끔하게 처음부터 daemonset를 설치할 수 있게 된다.

그렇지만 이 방법은 K8S에 올라가 있는 서비스가 일시적이지만 중단될 수 있는 위험을 가지고 있다.
그래서 찾은 방법이 [사용 가능한 IP 주소를 늘려](https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/cni-increase-ip-addresses.html) 해결하는 방법이다.


### 내 경우엔 어떻게 해야 하나

나는 Terraform으로 생성했기 때문에 eksctl과 콘솔 모두 사용하지 않음을 전제로 한다.
그래서 공식 문서에서 정말 수많은 것들을 배제해야 했고, 결론은 Launch Template을 생성해 이것을 통해 node group을 만드는 방법 뿐이다.

최대한 기능별로 멱등성을 유지하면서 스크립트를 작성하려 했지만 이번 경우에는 클러스터의 근간을 바꿔야 하는 작업이기 때문에 **1. eks-cluster**를 수정해야 한다.
기존에는 default로 만들었던 launch template을 수동으로 만들고 eks 용 AMI를 선택한 후 user data에 bootstrap.sh를 넣어주는 방법을 쓸 것이다.


### Reference

https://lcc3108.github.io/articles/2021-08/eks-too-many-pod
