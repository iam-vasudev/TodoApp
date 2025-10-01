#!/bin/bash

# Build and deploy React Todo App to AWS

set -e

# Variables
AWS_REGION="us-east-1"
ECR_REPO_NAME="react-todo-app"

echo "🚀 Starting deployment process..."

# 1. Build the Docker image
echo "📦 Building Docker image..."
docker build -t $ECR_REPO_NAME .

# 2. Initialize and apply Terraform
echo "🏗️  Setting up AWS infrastructure..."
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

# Get ECR repository URI
ECR_URI=$(terraform output -raw ecr_repository_uri)
echo "📍 ECR Repository: $ECR_URI"

# 3. Login to ECR and push image
echo "🔐 Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

# Tag and push image
echo "📤 Pushing image to ECR..."
docker tag $ECR_REPO_NAME:latest $ECR_URI:latest
docker push $ECR_URI:latest

# 4. Update App Runner service
echo "🔄 Updating App Runner service..."
aws apprunner start-deployment --service-arn $(aws apprunner list-services --query "ServiceSummaryList[?ServiceName=='react-todo-app'].ServiceArn" --output text)

echo "✅ Deployment complete!"
echo "🌐 App URL: $(terraform output -raw app_url)"