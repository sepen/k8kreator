#!/usr/bin/env bash

k8kreator-tools-install-helm() {
  local helm_version=$1
  local helm_url="https://get.helm.sh/helm-v${helm_version}"

  local system_os=$(k8kreator-get-system-os)
  local system_arch=$(k8kreator-get-system-arch)

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
