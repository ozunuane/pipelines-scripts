output "hosted_zone1_cert" {
  value = module.hosted_zone1_cert_dev.cert_arn_dns
}

output "hosted_zone1_cert_dev" {
  value = module.hosted_zone1_cert_dev.cert_arn_dns
}
