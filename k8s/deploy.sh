#!/bin/bash

echo "Creating namespace..."
kubectl apply -f 00-namespace.yaml

echo "Applying all resources..."
kubectl apply -f .
kubectl rollout restart deployment coredns -n kube-system
kubectl delete pod -n kube-system -l k8s-app=kube-dns
echo "Done!"
