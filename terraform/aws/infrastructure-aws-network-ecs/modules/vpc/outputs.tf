output "id" {
  value = aws_vpc.vpc.id
}

output "private_subnets" {
  value = module.private_subnets.subnet_id
}

output "public_subnets" {
  value = module.public_subnets.subnet_id
}

