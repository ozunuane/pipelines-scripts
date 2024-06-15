output "registry" {
  value = aws_service_discovery_service.service_discovery
}

output "fqdn" {
  value = aws_route53_record.account_dns[0].fqdn
}


output "name" {
  description = "Name of the service"
  value       = aws_ecs_service.service.name
}



output "cluster_arn" {
  value = aws_ecs_service.service.cluster

}
