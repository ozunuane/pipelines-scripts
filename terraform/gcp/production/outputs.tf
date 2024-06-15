output "bastion" {
  value     = module.bastion.bastion
  sensitive = true
}


output "cba-kubernetes" {
  value     = module.kubernetes.cba-kubernetes
  sensitive = true
}

output "noncba-kubernetes" {
  value     = module.kubernetes.noncba-kubernetes
  sensitive = true
}

output "postgres" {
  value     = {
    noncba = module.postgres.noncba
    cba    = module.postgres.cba
    }
  sensitive = true
}

output "redis" {
  value     = module.redis.redis
  sensitive = true
}

output "storage" {
  value     = module.storage.storage
  sensitive = true
}

# # output "lb" {
# #   value = {
# #     root          = module.lb.ip_address
# #     microservices = module.lb.microservice_urls
# #   }
# #   sensitive = true
# # }
