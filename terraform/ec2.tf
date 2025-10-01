# Key Pair
resource "aws_key_pair" "app" {
  key_name   = "${var.app_name}-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Security Group for EC2
resource "aws_security_group" "ec2" {
  name_prefix = "${var.app_name}-ec2-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2023
  instance_type          = "t3.micro"
  key_name              = aws_key_pair.app.key_name
  subnet_id             = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    db_endpoint = aws_db_instance.postgres.endpoint
    db_username = var.db_username
    db_password = var.db_password
    db_name     = aws_db_instance.postgres.db_name
  }))
  
  tags = {
    Name = "${var.app_name}-instance"
  }
}

# Outputs
output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

output "ec2_ssh_command" {
  value = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.app.public_ip}"
}