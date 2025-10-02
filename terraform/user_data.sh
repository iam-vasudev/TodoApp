#!/bin/bash
set -e


# Install Docker
if ! command -v docker >/dev/null 2>&1; then
apt-get update -y || true
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io
systemctl enable --now docker
fi


# Install SSM agent (for newer Ubuntu images)
if ! systemctl is-active --quiet amazon-ssm-agent; then
snap install amazon-ssm-agent --classic || apt-get install -y amazon-ssm-agent || true
systemctl enable --now amazon-ssm-agent || true
fi


# Ensure jq is available
if ! command -v jq >/dev/null 2>&1; then
apt-get install -y jq || true
fi


# Create a simple systemd service placeholder for the app
cat >/etc/systemd/system/todoapp.service <<'EOF'
[Unit]
Description=TodoApp container
After=docker.service


[Service]
Restart=always
ExecStartPre=-/usr/bin/docker rm -f todoapp
ExecStart=/usr/bin/docker run --rm --name todoapp -p 3000:3000 719108377965.dkr.ecr.us-east-1.amazonaws.com/todoapp:latest
ExecStop=/usr/bin/docker stop todoapp


[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable --now todoapp.service || true