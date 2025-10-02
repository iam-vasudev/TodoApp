# Find a recent Ubuntu AMI (uses canonical owner & Ubuntu 24.04 pattern if available).
# If this fails, change filters to your preferred AMI
data "aws_ami" "ubuntu" {
most_recent = true
owners = ["099720109477"] # Canonical
filter {
name = "name"
values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*", "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*", "ubuntu/images/hvm-ssd/ubuntu-*-24.04-amd64-server-*"]
}
}


resource "aws_instance" "app" {
ami = data.aws_ami.ubuntu.id
instance_type = var.instance_type
subnet_id = aws_subnet.public[0].id
vpc_security_group_ids = [aws_security_group.ec2_sg.id]
key_name = var.key_name != "" ? var.key_name : null
iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name


user_data = base64encode(file("./userdata.sh"))


tags = {
Name = "todoapp-ec2"
}
}


# Elastic IP to mimic your CloudFormation mapping
resource "aws_eip" "app_eip" {
instance = aws_instance.app.id
vpc = true
tags = { Name = "todoapp-eip" }
}