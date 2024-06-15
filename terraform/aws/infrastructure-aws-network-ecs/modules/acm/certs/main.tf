resource "aws_acm_certificate" "cert_dns" {
  count                     = var.domain_validation_options == "DNS" ? 1 : 0
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"
  options {
    certificate_transparency_logging_preference = var.certificate_transparency_logging_preference
  }
  tags = {
    "HostedZone"   = "${var.domain_name}"
    "Envrironment" = "${var.env}"
  }
}

# resource "aws_acm_certificate" "cert_email" {
#   count                     = var.domain_validation_options == "EMAIL" ? 1 : 0
#   domain_name               = var.domain_name
#   subject_alternative_names = var.subject_alternative_names
#   validation_method         = "EMAIL"
#   options {
#     certificate_transparency_logging_preference = var.certificate_transparency_logging_preference
#   }
#   tags = {
#     "HostedZone"   = "${var.domain_name}"
#     "Envrironment" = "${var.env}"
#   }
#   depends_on = [
#     aws_acm_certificate.cert_dns[0]
#   ]
# }

# data "aws_route53_zone" "dns_zone" {
#   name = "${var.dns_zone == "example.com" ? var.domain_name : var.dns_zone}."
# }

# resource "aws_route53_record" "cert_dns_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert_dns[*].domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
#   allow_overwrite = var.allow_overwrite
#   zone_id         = data.aws_route53_zone.dns_zone.zone_id
#   name            = each.value.name
#   type            = each.value.type
#   records         = [each.value.record]
#   #records         = [trim(each.value.record, ".")]
#   ttl = var.ttl
#   depends_on = [
#     aws_acm_certificate.cert_dns[0]
#   ]
# }

# resource "aws_acm_certificate_validation" "validate_cert" {
#   count                   = var.process_domain_validation_options && var.wait_for_certificate_issued ? 1 : 0
#   certificate_arn         = aws_acm_certificate.cert_dns[0].arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_dns_validation : record.fqdn]
#   depends_on = [
#     aws_acm_certificate.cert_dns[0]
#   ]
# }