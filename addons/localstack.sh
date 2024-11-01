#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

post-install() {
  k8kreator-msg-info "IMPORTANT: To use localstack you need awscli and awscli-local installed."
  k8kreator-msg-info "It may be useful to configure some environment variables and create an alias:"
  k8kreator-msg-info "  export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_REGION=eu-west-1"
  k8kreator-msg-info "  alias awslocal='aws --endpoint-url=http://localstack.k8kreator.kind.local'"
  k8kreator-msg-info "After that you should be able to run commands like:"
  k8kreator-msg-info "  awslocal s3 mb s3://mybucket"
  k8kreator-msg-info "  awslocal s3api list-buckets"
  k8kreator-msg-info "  awslocal ec2 create-vpc --cidr-block 10.0.0.0/20"
  k8kreator-msg-info "  awslocal ec2 describe-vpcs"
}

k8kreator-addons-install-localstack() {
  k8kreator-addons-update-localstack $@
}

k8kreator-addons-update-localstack() {
  local addon_version=$1
  ${HELM_COMMAND} upgrade localstack localstack \
    --repo https://helm.localstack.cloud \
    --version ${addon_version} \
    --create-namespace --namespace localstack \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_ADDONSDIR}/localstack/values.yaml \
    --set "ingress.hosts[0].host=localstack.${K8KREATOR_TARGET}"
  post-install
}

k8kreator-addons-uninstall-localstack() {
  local addon_version=$1
  ${HELM_COMMAND} uninstall localstack \
    --namespace localstack
}

# End of file
