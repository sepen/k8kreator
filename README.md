<img src="https://github.com/sepen/k8kreator/assets/11802175/79f55123-f1ee-49c5-9d96-068c055584d5" width="116" text-align="center">

# [`k8kreator`](/)

Lightweight wrapper to manage Kubernetes clusters

![Last Commit](https://img.shields.io/github/last-commit/sepen/k8kreator)
![Repo Size](https://img.shields.io/github/repo-size/sepen/k8kreator)
![Code Size](https://img.shields.io/github/languages/code-size/sepen/k8kreator)
![Proudly Written in Bash](https://img.shields.io/badge/written%20in-bash-ff69b4)

<img src="https://user-images.githubusercontent.com/11802175/284404560-3d635480-c3f4-4521-ae0d-b4fe074bc0b1.gif" width="80%" text-align="center">


## Features

* Ease of creating and maintaining local clusters with different engines ([kind](https://kind.sigs.k8s.io/), [k3d](https://k3d.io/) and [minikube](https://minikube.sigs.k8s.io/))
* Addons for easily installed Kubernetes applications
* Ability to test the latest versions of Kubernetes and installed Kubernetes applications
* Cross-platform (Linux and macOS)
* Automatic configuration of a _load-balancer_ 


## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
* [Targets](#targets)
* [Engines](#engines)
* [Addons](#addons)
* [Important Notes](#important-notes)
* [Troubleshooting](#troubleshooting)


## Installation

To install [`k8kreator`](/) paste that in a macOS Terminal or Linux shell prompt:
```
curl -fsSL https://raw.githubusercontent.com/sepen/k8kreator/main/k8kreator | bash -s self install
```

* The one-liner command from above installs [`k8kreator`](/) to its default, `$HOME/.k8kreator` and will place some files under that prefix, so you'll need to set your PATH like this `export PATH=$HOME/.k8kreator/bin:$PATH`.
* The installation explains what it will do, and you will see all that information. Consider adding this line to your _~/.bashrc_ or _~/.bash_profile_ or make sure to export this _PATH_ before running [`k8kreator`](/). The installation explains what it will do.
* The one-liner installation method found on [`k8kreator`](/) uses Bash. Notably, zsh, fish, tcsh and csh will not work.


## Usage

Create a new cluster
```
k8kreator cluster create
```

Install some addons
```
k8kreator addons install metrics-server metallb ingress-nginx jenkins
```

Run `k8kreator help` for more information

## Environment Variables

Run `k8kreator env` to get a complete list of environment variables. Most notable are:

| Variable | Defaults | Description |
|----------|----------|-------------|
| K8KREATOR_TARGET | k8kreator.kind.local | Active cluster target. Run 'k8kreator cluster list' to get all available targets |
| K8KREATOR_DEBUG | 0 | Indicate whether or not k8kreator is running in Debug mode |
| K8KREATOR_NOCOLOR | 0 | Disable colored output messages. Set K8KREATOR_NOCOLOR=1 to disable |
| K8KREATOR_BINDIR | $HOME/.k8kreator/bin | Path location for binary files |
| K8KREATOR_SRCDIR | $HOME/.k8kreator/src | Path location for source files |


## Targets

Targets are the reference units to create a cluster (`name.engine.domain`). By default k8kreator provides the following targets:

| Name | Kubernetes | Tools |
|------|-----------:|-------|
| [k8kreator.kind.local](targets/k8kreator.kind.local) | v1.31.0 | kind=0.24.0 kubectl=1.31.0 helm=3.16.1 |
| [k8kreator.k3d.local](targets/k8kreator.k3d.local) | v1.30.2-rc3+k3s1 | k3d=5.7.4 kubectl=1.31.0 helm=3.16.1 |
| [k8kreator.minikube.local](targets/k8kreator.minikube.local) | v1.31.0 | minikube=1.34.0 kubectl=1.31.0 helm=3.16.1 |

Local targets are located in `~/.k8kreator/src/targets`

## Engines

At the moment the supported engines are the following:

| Name | Description |
|--------|-------------|
| [kind](https://kind.sigs.k8s.io/) | A tool for running local Kubernetes clusters using Docker container “nodes” |
| [k3d](https://k3d.io/) | A lightweight wrapper to run k3s (Rancher Lab's minimal Kubernetes distribution) in docker |
| [minikube](https://minikube.sigs.k8s.io/) | A tool for running a local Kubernetes cluster, focusing on making it easy to learn and develop for Kubernetes |


## Addons

Addons are maintained extensions used for added functionality to clusters. At this moment the addons available are the following:

| Name | Description |
|-------|-------------|
| [metrics-server](https://github.com/kubernetes-sigs/metrics-server/) | It collects resource metrics from Kubelets and exposes them in Kubernetes apiserver through Metrics API |
| [metallb](https://metallb.universe.tf/) | A load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols |
| [ingress-nginx](https://github.com/kubernetes/ingress-nginx/) | An Ingress controller for Kubernetes using Nginx as a reverse proxy and load-balancer |
| [kubernetes-dashboard](https://github.com/kubernetes/dashboard) | Web-based UI that allows administrators to perform basic operating tasks and review cluster events |
| [kubewatch](https://github.com/robusta-dev/kubewatch) | Kubernetes watcher that publishes notifications to Slack/hipchat/mattermost/flock channels |
| [jenkins](https://www.jenkins.io/) | Continuous integration/continuous delivery and deployment (CI/CD) automation software DevOps tool |
| [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/) | kube-prometheus-stack collects Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator |
| [promtail](https://grafana.com/docs/loki/latest/send-data/promtail/) | An agent which ships the contents of local logs to a private Grafana Loki instance or Grafana Cloud |
| [loki](https://grafana.com/docs/loki/latest/) | Horizontally-scalable, highly-available, multi-tenant log aggregation system inspired by Prometheus |
| [tempo](https://grafana.com/docs/tempo/latest/) | Easy-to-use, and high-scale distributed tracing backend |
| [localstack](https://localstack.cloud/) | Cloud service emulator that can run your AWS applications or Lambdas entirely on your local machine |



Local addons are located in `~/.k8kreator/src/addons`


## Important Notes

The idea behind [`k8kreator`](/) is to be able to run clusters with different Kubernetes engines and have a homogeneous way to install and maintain cluster addons. It was primarily designed for testing Kubernetes itself, but may be used for local development or CI (you can use it in production but it's not what it's designed for, so do it at your own risk).


## Troubleshooting

With Docker on _Linux_, you can send traffic directly to the load-balancer’s external IP if the IP space is within the docker IP space.

On _macOS_ and _Windows_, docker does not expose the docker network to the host. Because of this limitation, containers (including nodes) are only reachable from the host via port-forwards, however other containers/pods can reach other things running in docker including load-balancers. You may want to check out the [Ingress Guide](https://kind.sigs.k8s.io/docs/user/ingress) as a cross-platform workaround. You can also expose pods and services using extra port mappings.

On _macOS_ you can try [docker-mac-net-connect](https://github.com/chipmk/docker-mac-net-connect) to use a load-balancer's external IP.
