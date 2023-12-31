#!/usr/bin/env bash

k8kreator-tools-install-helm() {
  local helm_version=$1
  local helm_url="https://get.helm.sh/helm-v${helm_version}"
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

  helm_url="${helm_url}-${system_os}-${system_arch}.tar.gz"

  if [ ! -f ${K8KREATOR_BINDIR}/helm-${helm_version} ]; then
    k8kreator-check-deps "curl" "mkdir" "tar" "cp" "chmod" "rm"
    curl -s -L -o ${K8KREATOR_TMPDIR}/helm-${helm_version}.tar.gz ${helm_url}
    mkdir -p ${K8KREATOR_TMPDIR}/helm-${helm_version}
    tar -C ${K8KREATOR_TMPDIR}/helm-${helm_version} -xf ${K8KREATOR_TMPDIR}/helm-${helm_version}.tar.gz
    cp ${K8KREATOR_TMPDIR}/helm-${helm_version}/${system_os}-${system_arch}/helm ${K8KREATOR_BINDIR}/helm-${helm_version}
    chmod +x ${K8KREATOR_BINDIR}/helm-${helm_version}
    rm -rf ${K8KREATOR_TMPDIR}/helm-${helm_version}
  fi
}

k8kreator-tools-select-helm() {
  local helm_version=$1
  k8kreator-check-deps "rm" "ln"
  rm -f ${K8KREATOR_BINDIR}/helm
  ln -sf helm-${helm_version} ${K8KREATOR_BINDIR}/helm
}

k8kreator-tools-uninstall-helm() {
  local helm_version=$1
  k8kreator-check-deps "rm"
  rm -f ${K8KREATOR_BINDIR}/helm-${helm_version}
}

# End of file
