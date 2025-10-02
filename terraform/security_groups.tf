resource "aws_security_group" "ec2_sg" {
name = "todoapp-ec2-sg"
description = "Allow SSH, HTTP, HTTPS and app port 3000"
vpc_id = aws_vpc.main.id


ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
description = "SSH"
}


ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
description = "HTTP"
}


ingress {
from_port = 443
to_port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
description = "HTTPS"
}


ingress {
from_port = 3000
to_port = 3000
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
description = "TodoApp port"
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}


tags = { Name = "todoapp-ec2-sg" }
}