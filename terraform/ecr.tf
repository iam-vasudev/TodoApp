data "aws_ecr_repository" "todoapp" {
  name = var.ecr_repo_name
}