# jaeger-operator

[nemo-aws](https://github.com/kaonmir/nemo-aws) is a AWS migration project configured by [Kaonmir](https://github.com/kaonmir)

# 아래는 아직 작성되지 않은 샘플입니다.


## Install

```console
$ helm install jaegertracing/jaeger-operator
```

## Introduction

This chart bootstraps a jaeger-operator deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.



## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the jaeger-operator chart and their default values.


Specify each parameter you'd like to override using a YAML file as described above in the [installation](#installing-the-chart) section.

You can also specify any non-array parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,
