#!/usr/bin/env bash

k8kreator-tools-install-kubectl() {
    local kubectl_version=$1
    local kubectl_url="https://dl.k8s.io/release/v${kubectl_version}/bin"
    local system_uname=($(uname -m -s))
 
    local system_os=
    case ${system_uname[0]} in
        Linux) system_os="linux" ;;
        Darwin) system_os="darwin" ;;
    esac

    local system_arch=
    case ${system_uname[1]} in
        x86_64) system_arch="amd64" ;;
        arm64) system_arch="arm64" ;;
    esac

    kubectl_url="${kubectl_url}/${system_os}/${system_arch}/kubectl"

    if [ ! -f ${K8KREATOR_HOME}/bin/kubectl-${kubectl_version} ]; then
        k8kreator-msg-info "Installing kubectl ${kubectl_version}"
        curl -s -L -o ${K8KREATOR_HOME}/bin/kubectl-${kubectl_version} ${kubectl_url}
        chmod +x ${K8KREATOR_HOME}/bin/kubectl-${kubectl_version}
    fi
}

k8kreator-tools-select-kubectl() {
    local kubectl_version=$1
    k8kreator-check-deps "rm" "ln"
    rm -f ${K8KREATOR_HOME}/bin/kubectl
    ln -sf kubectl-${kubectl_version} ${K8KREATOR_HOME}/bin/kubectl
}

# End of file