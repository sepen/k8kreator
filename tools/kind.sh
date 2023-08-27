#!/usr/bin/env bash

k8kreator-tools-install-kind() {
    local kind_version=$1
    local kind_url="https://github.com/kubernetes-sigs/kind/releases/download/v${kind_version}"
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

    kind_url="${kind_url}/kind-${system_os}-${system_arch}"

    if [ ! -f ${K8KREATOR_HOME}/bin/kind-${kind_version} ]; then
        k8kreator-check-deps "curl" "chmod"
        k8kreator-msg-info "Installing kind ${kind_version}"
        curl -s -L -o ${K8KREATOR_HOME}/bin/kind-${kind_version} ${kind_url}
        chmod +x ${K8KREATOR_HOME}/bin/kind-${kind_version}
    fi
}

k8kreator-tools-select-kind() {
    local kind_version=$1
    k8kreator-check-deps "rm" "ln"
    rm -f ${K8KREATOR_HOME}/bin/kind
    ln -sf kind-${kind_version} ${K8KREATOR_HOME}/bin/kind
}

k8kreator-tools-uninstall-kind() {
  local kind_version=$1
  k8kreator-check-deps "rm"
  rm -f ${K8KREATOR_HOME}/bin/kind-${kind_version}
}

# End of file
