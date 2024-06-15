output "subnet_id" {
  value = values(aws_subnet.subnet)[*].id
}