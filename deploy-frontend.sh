#!/bin/bash
set -e

AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="207138464032"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE="${ECR_REGISTRY}/aws-k8s-demo-frontend:v5"
EC2_HOST="ubuntu@34.239.164.52"
SSH_KEY="$HOME/.ssh/mackeypair.pem"

echo "Checking AWS identity..."
aws sts get-caller-identity >/dev/null || {
  echo "AWS session expired. Run: aws sso login"
  exit 1
}

echo "Logging Docker into ECR..."
aws ecr get-login-password --region "$AWS_REGION" | \
docker login --username AWS --password-stdin "$ECR_REGISTRY"

echo "Building and pushing frontend image..."
docker buildx build \
  --no-cache \
  --platform linux/amd64 \
  -t "$IMAGE" \
  ./frontend \
  --push

echo "Refreshing Kubernetes ECR pull secret and restarting frontend..."
ssh -i "$SSH_KEY" "$EC2_HOST" << 'EOF'
set -e

AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="207138464032"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

aws ecr get-login-password --region "$AWS_REGION" > token.txt

sudo kubectl delete secret ecr-creds -n demo --ignore-not-found

sudo kubectl create secret docker-registry ecr-creds \
  --namespace demo \
  --docker-server="$ECR_REGISTRY" \
  --docker-username=AWS \
  --docker-password="$(cat token.txt)"

rm token.txt

sudo kubectl apply -f ~/k8s/frontend-deployment.yaml
sudo kubectl rollout restart deployment/frontend -n demo
sudo kubectl rollout status deployment/frontend -n demo

FRONTEND_POD=$(sudo kubectl get pods -n demo -l app=frontend -o jsonpath='{.items[0].metadata.name}')

echo "Verifying deployed content..."
sudo kubectl exec -n demo "$FRONTEND_POD" -- grep -n "github" /usr/share/nginx/html/index.html || true
sudo kubectl exec -n demo "$FRONTEND_POD" -- grep -n "HTTP to HTTPS" /usr/share/nginx/html/index.html || true
EOF

echo "Deployment complete."
echo "Open: https://abigail-devops.com"
