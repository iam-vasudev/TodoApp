# Create IAM role for EC2 with ECR read & SSM
resource "aws_iam_role" "ec2_role" {
name = "todoapp-ec2-role"
assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


data "aws_iam_policy_document" "ec2_assume_role" {
statement {
actions = ["sts:AssumeRole"]
principals {
type = "Service"
identifiers = ["ec2.amazonaws.com"]
}
}
}


resource "aws_iam_role_policy_attachment" "ecr_readonly" {
role = aws_iam_role.ec2_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


resource "aws_iam_role_policy_attachment" "ssm_core" {
role = aws_iam_role.ec2_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
name = "todoapp-instance-profile"
role = aws_iam_role.ec2_role.name
}


