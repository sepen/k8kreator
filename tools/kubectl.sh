#!/usr/bin/env bash

k8kreator-tools-install-kubectl() {
  local kubectl_version=$1
  local kubectl_url="https://dl.k8s.io/release/v${kubectl_version}/bin"

  local system_os=$(k8kreator-get-system-os)
  local system_arch=$(k8kreator-get-system-arch)

  kubectl_url="${kubectl_url}/${system_os}/${system_arch}/kubectl"

  if [ ! -f ${K8KREATOR_BINDIR}/kubectl-${kubectl_version} ]; then
    curl -s -L -o ${K8KREATOR_BINDIR}/kubectl-${kubectl_version} ${kubectl_url}
    chmod +x ${K8KREATOR_BINDIR}/kubectl-${kubectl_version}
  fi
}

k8kreator-tools-select-kubectl() {
  local kubectl_version=$1
  k8kreator-check-deps "rm" "ln"
  rm -f ${K8KREATOR_BINDIR}/kubectl
  ln -sf kubectl-${kubectl_version} ${K8KREATOR_BINDIR}/kubectl
}

k8kreator-tools-uninstall-kubectl() {
  local kubectl_version=$1
  k8kreator-check-deps "rm"
  rm -f ${K8KREATOR_BINDIR}/kubectl-${kubectl_version}
}

# End of file
