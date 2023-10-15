<img src="https://github.com/sepen/k8kreator/assets/11802175/79f55123-f1ee-49c5-9d96-068c055584d5" width="200" text-align="center">

# `k8kreator`

Lightweight wrapper to manage Kubernetes clusters

![Last Commit](https://img.shields.io/github/last-commit/sepen/k8kreator)
![Repo Size](https://img.shields.io/github/repo-size/sepen/k8kreator)
![Code Size](https://img.shields.io/github/languages/code-size/sepen/k8kreator)
![Proudly Written in Bash](https://img.shields.io/badge/written%20in-bash-ff69b4)

---

## Installation

To install **k8kreator** paste that in a macOS Terminal or Linux shell prompt:
```
$ curl -fsSL https://raw.githubusercontent.com/sepen/k8kreator/main/k8kreator | bash -s self install
```

The one-liner command from above installs **k8kreator** to its default, `$HOME/.k8kreator` and will place some files under that prefix, so you'll need to set your PATH like this `export PATH=$HOME/.k8kreator/bin:$PATH`. \
The installation explains what it will do, and you will see all that information. Consider adding this line to your _~/.bashrc_ or _~/.bash_profile_ or make sure to export this _PATH_ before running **k8kreator**. The installation explains what it will do. \
The one-liner installation method found on **k8kreator** uses Bash. Notably, zsh, fish, tcsh and csh will not work.

---

## Usage

```
Usage:
  k8kreator [command]

Available Commands:
  self      Install or update k8kreator itself
  cluster   List, create or delete clusters (it will use K8KREATOR_TARGET)
  addons    Install, update, list or uninstall addons for the cluster target
  tools     Install, update, list or uninstall tools for the cluster target
  version   Print k8kreator version information
  env       Print k8kreator environment variables
  help      Print help information

Flags:
      --debug        Enable debug messages
      --nocolor      Disable colored output mmessages
      --version      Print k8kreator version information
      --env          Print k8kreator environment variables
  -h, --help         Print help information
  -t, --target id    Set the cluster target. Overrides K8KREATOR_TARGET from environment variable

Environment variables:

| Name               | Description                                                              |
|--------------------|--------------------------------------------------------------------------|
| K8KREATOR_DEBUG    | Indicate whether or not k8kreator is running in Debug mode               |
| K8KREATOR_HOME     | Alternative path for k8kreator's base directory (default ~/.k8kreator)   |
| K8KREATOR_TARGET   | Active cluster target. Run 'k8kreator cluster list' to get all available |
| K8KREATOR_NOCOLOR  | Disable colored output messages. Set K8KREATOR_NOCOLOR=1 to disable      |
| K8KREATOR_BINDIR   | Alternative path for binary files (default ~/.k8kreator/bin)             |
| K8KREATOR_SRCDIR   | Alternative path for source directory (default ~/.k8kreator/src)         |
| K8KREATOR_TMPDIR   | Alternative path for temporary files (default ~/.k8kreator/tmp)          |
```

---

## Overview

The idea behind **k8kreator** is to be able to run clusters with different Kubernetes engines and have a homogeneous way to install and maintain cluster addons. It was primarily designed for testing Kubernetes itself, but may be used for local development or CI (you can use it in production but it's not what it's designed for, so do it at your own risk).

At this moment **k8kreator** supports the following Kubernetes engines:
* [kind]. A tool for running local Kubernetes clusters using Docker container “nodes”.
* [k3d]. A lightweight wrapper to run k3s (Rancher Lab's minimal Kubernetes distribution) in docker.
* [minikube]. A tool for running a local Kubernetes cluster, focusing on making it easy to learn and develop for Kubernetes.

[kind]: https://kind.sigs.k8s.io/
[k3d]: https://k3d.io/
[minikube]: https://minikube.sigs.k8s.io/

Each cluster in **k8kreator** can be identified as a _target_: `<name>.<engine>.<environment>`.
Each _target_ has its own configuration for the Kubernetes engine and a set of _addons_ to populate the cluster. These _addons_ may vary from one _target_ to another and may have different configuration depending on the Kubernetes engine.

**k8kreator** provides the following _default_ targets:
* `default.kind.local`
* `default.k3d.local`
* `default.minukube.local`

The _default_ targets help to have a cluster with a minimum base to be used as a starting point. They consist of only two nodes: a control-plane and a worker.

The cluster _addons_ that come in the default targets are the following:
* [metrics-server]. It collects resource metrics from Kubelets and exposes them in Kubernetes apiserver through Metrics API.
* [metallb].  A load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.
* [ingress-nginx]. An Ingress controller for Kubernetes using Nginx as a reverse proxy and load balancer.

[metrics-server]: https://github.com/kubernetes-sigs/metrics-server/
[metallb]: https://metallb.universe.tf/
[ingress-nginx]: https://github.com/kubernetes/ingress-nginx/

In addition to targets above you can add your own custom _target_. To create it you can use _default_ targets as a template and remove or add addons as needed.

---

## Important Notes

With Docker on _Linux_, you can send traffic directly to the loadbalancer’s external IP if the IP space is within the docker IP space.

On _macOS_ and _Windows_, docker does not expose the docker network to the host. Because of this limitation, containers (including nodes) are only reachable from the host via port-forwards, however other containers/pods can reach other things running in docker including loadbalancers. You may want to check out the [Ingress Guide](https://kind.sigs.k8s.io/docs/user/ingress) as a cross-platform workaround. You can also expose pods and services using extra port mappings.
