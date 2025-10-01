#!/bin/bash

# Deploy React Todo App to EC2

set -e

echo "🚀 Deploying to EC2..."

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "🔑 Generating SSH key..."
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
fi

# Deploy infrastructure
cd terraform
terraform init
terraform apply -auto-approve

# Get EC2 IP
EC2_IP=$(terraform output -raw ec2_public_ip)
DB_ENDPOINT=$(terraform output -raw database_endpoint)

echo "✅ Infrastructure deployed!"
echo "🖥️  EC2 IP: $EC2_IP"
echo "🗄️  Database: $DB_ENDPOINT"

# Wait for instance to be ready
echo "⏳ Waiting for EC2 instance to be ready..."
sleep 60

# Copy app files to EC2
echo "📁 Copying app files..."
scp -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -r ../app ../components ../lib ../styles ../public ../package.json ../next.config.mjs ../tsconfig.json ../tailwind.config.ts ../postcss.config.mjs ec2-user@$EC2_IP:/home/ec2-user/

# SSH and setup app
echo "🔧 Setting up app on EC2..."
ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ec2-user@$EC2_IP << EOF
cd /home/ec2-user
npm install
npm run build
sudo systemctl restart todo-app
EOF

echo "✅ Deployment complete!"
echo "🌐 App URL: http://$EC2_IP:3000"