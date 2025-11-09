#!/bin/bash

# Deploy Blackjack Application to Kubernetes
# This script automates the deployment of the Blackjack application

set -e

# Configuration
NAMESPACE="blackjack"
IMAGE_REPO="ghcr.io/nathan47293/blackjack-devops-ia"
TAG="${1:-latest}"

echo "🚀 Deploying Blackjack Application"
echo "=================================="
echo "Namespace: $NAMESPACE"
echo "Image: $IMAGE_REPO:$TAG"
echo ""

# Create namespace if it doesn't exist
echo "📦 Creating namespace..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Apply ConfigMap and Secrets
echo "🔧 Applying configuration..."
kubectl apply -f k8s/configmap.yaml -n $NAMESPACE

# Update deployment image
echo "🛠️ Updating deployment image..."
sed "s|image: .*|image: $IMAGE_REPO:$TAG|" k8s/deployment.yaml | kubectl apply -f - -n $NAMESPACE

# Apply other resources
echo "🌐 Applying services and networking..."
kubectl apply -f k8s/service.yaml -n $NAMESPACE
kubectl apply -f k8s/ingress.yaml -n $NAMESPACE
kubectl apply -f k8s/hpa.yaml -n $NAMESPACE

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/blackjack-app -n $NAMESPACE

# Get service information
echo "📋 Deployment complete!"
echo ""
echo "Service information:"
kubectl get services -n $NAMESPACE

echo ""
echo "Pod status:"
kubectl get pods -n $NAMESPACE

echo ""
echo "🎉 Application deployed successfully!"
echo "Access the application at: http://$(kubectl get service blackjack-service -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"