echo "Follow https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html to install AWS CLI"

apt install linuxbrew-wrapper -y
brew update

brew install kubectl 
brew install jq
brew install argocd 
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# install istioctln
curl -sL https://istio.io/downloadIstioctl | sh -
cp $HOME/.istioctl/bin/istioctl /usr/local/bin/istioctl
rm -rf $HOME/.istioctl


echo "In advanced to run this commands, you must login to AWS CLI with your credential ."