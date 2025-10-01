#!/bin/bash
yum update -y
yum install -y docker git

# Start Docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install Node.js
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Clone and setup app
cd /home/ec2-user
git clone https://github.com/your-username/react-todo-app.git || echo "Using local files"

# Create app directory if git clone failed
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Create package.json
cat > package.json << 'EOF'
{
  "name": "react-todo-app",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "^18",
    "react-dom": "^18",
    "pg": "^8.11.3"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "autoprefixer": "^10.0.1",
    "eslint": "^8",
    "eslint-config-next": "14.0.0",
    "postcss": "^8",
    "tailwindcss": "^3.3.0",
    "typescript": "^5"
  }
}
EOF

# Set environment variables
cat > .env.local << EOF
NODE_ENV=production
DATABASE_URL=postgresql://${db_username}:${db_password}@${db_endpoint}/${db_name}
EOF

# Install dependencies and build
npm install
npm run build

# Create systemd service
cat > /etc/systemd/system/todo-app.service << EOF
[Unit]
Description=React Todo App
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/app
Environment=NODE_ENV=production
Environment=DATABASE_URL=postgresql://${db_username}:${db_password}@${db_endpoint}/${db_name}
ExecStart=/usr/bin/npm start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Change ownership
chown -R ec2-user:ec2-user /home/ec2-user/app

# Enable and start service
systemctl daemon-reload
systemctl enable todo-app
systemctl start todo-app