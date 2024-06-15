output "cert_arn_dns" {
  value = var.domain_validation_options == "DNS" ? aws_acm_certificate.cert_dns[0].arn : null
}

# output "cert_arn_email" {
#   value = var.domain_validation_options == "EMAIL" ? aws_acm_certificate.cert_email[0].arn : null
# }