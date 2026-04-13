#!/bin/bash

echo "Creating namespace..."
kubectl apply -f 00-namespace.yaml

echo "Applying all resources..."
kubectl apply -f .

echo "Done!"
