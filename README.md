# `k8kreator`

Lightweight wrapper to manage Kubernetes clusters

![Last Commit](https://img.shields.io/github/last-commit/sepen/k8kreator)
![Repo Size](https://img.shields.io/github/repo-size/sepen/k8kreator)
![Code Size](https://img.shields.io/github/languages/code-size/sepen/k8kreator)
![Proudly Written in Bash](https://img.shields.io/badge/written%20in-bash-ff69b4)


## Installation

To install **k8kreator** paste that in a macOS Terminal or Linux shell prompt:
```
$ curl -fsSL https://raw.githubusercontent.com/sepen/k8kreator/main/k8kreator | bash -s self install
```


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
