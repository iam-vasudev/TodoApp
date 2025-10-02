resource "aws_ecr_repository" "todoapp" {
name = var.ecr_repo_name
image_tag_mutability = "MUTABLE"
tags = { Name = "todoapp-ecr" }
}