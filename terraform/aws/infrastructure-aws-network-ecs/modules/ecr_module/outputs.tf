output "repositry_url" {
  value = {
    for key, value in aws_ecr_repository.ecr : key => value.repository_url
  }
}