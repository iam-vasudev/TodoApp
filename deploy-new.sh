#!/bin/bash

# Build and deploy React Todo App to AWS with VPC and RDS

set -e

# Variables
AWS_REGION="us-east-1"
APP_NAME="react-todo-app"

echo "🚀 Starting deployment process..."

# 1. Build the Docker image
echo "📦 Building Docker image..."
docker build -t $APP_NAME .

# 2. Initialize and apply Terraform
echo "🏗️  Setting up AWS infrastructure..."
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

# Get outputs
ECR_URI=$(terraform output -raw ecr_repository_uri)
DB_ENDPOINT=$(terraform output -raw database_endpoint)
echo "📍 ECR Repository: $ECR_URI"
echo "🗄️  Database Endpoint: $DB_ENDPOINT"

# 3. Login to ECR and push image
echo "🔐 Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

# Tag and push image
echo "📤 Pushing image to ECR..."
docker tag $APP_NAME:latest $ECR_URI:latest
docker push $ECR_URI:latest

# 4. Update ECS service
echo "🔄 Updating ECS service..."
aws ecs update-service --cluster $APP_NAME --service $APP_NAME --force-new-deployment

echo "✅ Deployment complete!"
echo "🌐 App will be available on ECS Fargate"
echo "🗄️  Database: $DB_ENDPOINT"