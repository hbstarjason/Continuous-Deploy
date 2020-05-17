#!/bin/bash

# 

kubectl create namespace argo-rollouts

kubectl apply -n argo-rollouts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml

kubectl get po  -n argo-rollouts

kubectl get crd

curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64 && \
  chmod +x ./kubectl-argo-rollouts-linux-amd64 && \
  sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts && \
  kubectl argo rollouts version