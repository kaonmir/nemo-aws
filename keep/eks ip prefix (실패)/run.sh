kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true

kubectl set env ds aws-node -n kube-system WARM_PREFIX_TARGET=1
# kubectl set env ds aws-node -n kube-system WARM_IP_TARGET=5
# kubectl set env ds aws-node -n kube-system MINIMUM_IP_TARGET=2

CLUSTER_NAME=nemo

chmod +x bootstrap.sh
./bootstrap.sh $CLUSTER_NAME \
  --use-max-pods false \
  --kubelet-extra-args '--max-pods=110'

# EKS IP Prefix 적용시 인스턴스 노드의 최대 pod 개수
POD_TYPE="t3.medium"

curl -o max-pods-calculator.sh https://raw.githubusercontent.com/awslabs/amazon-eks-ami/master/files/max-pods-calculator.sh
chmod +x max-pods-calculator.sh
CNI_VERSION=$(kubectl describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2 | cut -d ":" -f 2  | cut -c 2- | head -1 | tr -d "\n")
./max-pods-calculator.sh --instance-type $POD_TYPE --cni-version $CNI_VERSION --cni-prefix-delegation-enabled
