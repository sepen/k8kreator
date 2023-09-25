#!/usr/bin/env bash

k8kreator-tools-install-minikube() {
  local minikube_version=$1
  local minikube_url="https://github.com/kubernetes/minikube/releases/download/v${minikube_version}"
  local system_uname=($(uname -m -s))
    
  local system_os=
  case ${system_uname[0]} in
    Linux) system_os="linux" ;;
    Darwin) system_os="darwin" ;;
  esac

  local system_arch=
  case ${system_uname[1]} in
    x86_64|amd64) system_arch="amd64" ;;
    aarch64|arm64) system_arch="arm64" ;;
  esac

  minikube_url="${minikube_url}/minikube-${system_os}-${system_arch}"

  if [ ! -f ${K8KREATOR_BINDIR}/minikube-${minikube_version} ]; then
    k8kreator-check-deps "curl" "chmod"
    curl -s -L -o ${K8KREATOR_BINDIR}/minikube-${minikube_version} ${minikube_url}
    chmod +x ${K8KREATOR_BINDIR}/minikube-${minikube_version}
  fi
}

k8kreator-tools-select-minikube() {
  local minikube_version=$1
  k8kreator-check-deps "rm" "ln"
  rm -f ${K8KREATOR_BINDIR}/minikube
  ln -sf minikube-${minikube_version} ${K8KREATOR_BINDIR}/minikube
}

k8kreator-tools-uninstall-minikube() {
  local minikube_version=$1
  k8kreator-check-deps "rm"
  rm -f ${K8KREATOR_BINDIR}/minikube-${minikube_version}
}

# End of file
