#!/bin/bash

echo "Creating namespace..."
kubectl apply -f 00-namespace.yaml

echo "Applying all resources..."
kubectl apply -f .
kubectl rollout restart deployment coredns -n kube-system
echo "Done!"
