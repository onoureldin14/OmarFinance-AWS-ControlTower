#!/bin/bash
set -e

REGION="eu-west-1"
REPO_NAME="ecr-vulnerable-demo"
IMAGE_TAG="latest"
export AWS_PROFILE="security"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

aws ecr create-repository --repository-name "$REPO_NAME" --region "$REGION" || echo "Repo may already exist"

aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

# Disable BuildKit
DOCKER_BUILDKIT=0 docker build -t "$REPO_NAME:$IMAGE_TAG" .

docker tag "$REPO_NAME:$IMAGE_TAG" "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/$REPO_NAME:$IMAGE_TAG"
docker push "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/$REPO_NAME:$IMAGE_TAG"

aws ecr start-image-scan \
  --repository-name "$REPO_NAME" \
  --image-id imageTag="$IMAGE_TAG" \
  --region "$REGION"

echo "Waiting for scan to complete..."
sleep 20

aws ecr describe-image-scan-findings \
  --repository-name "$REPO_NAME" \
  --image-id imageTag="$IMAGE_TAG" \
  --region "$REGION" \
  --query 'imageScanFindings.findingSeverityCounts'
