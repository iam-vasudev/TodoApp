# This example defines an autoscaling group using the same launch configuration as the single instance.
# For simplicity this is left commented; enable if you want an ASG.


# output and final notes
############################################################
# outputs.tf
############################################################
output "ec2_public_ip" {
description = "Public IP of the EC2 instance"
value = aws_eip.app_eip.public_ip
}


output "nlb_dns" {
description = "NLB DNS name"
value = aws_lb.nlb.dns_name
}


output "ecr_repo_url" {
description = "ECR repository URL"
value = aws_ecr_repository.todoapp.repository_url
}