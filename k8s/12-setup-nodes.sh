#!/bin/bash

minikube start --nodes 3 --cpus 4 --memory 8192 --disk-size 20g --driver=docker

echo "Setting up nodes..."

# Label nodes
kubectl label node minikube type=general --overwrite
kubectl label node minikube-m02 type=high-memory --overwrite
kubectl label node minikube-m03 type=high-memory --overwrite
# Taint database node
kubectl taint nodes minikube node-role.kubernetes.io/control-plane=true:NoSchedule
kubectl taint node minikube-m02 database-only=true:NoSchedule --overwrite

echo "Done!"
