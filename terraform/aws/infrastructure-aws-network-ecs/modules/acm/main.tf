module "hosted_zone1_cert" {
  source                      = "./certs"
  domain_name                 = var.hosted_zone1
  domain_validation_options   = "DNS"
  subject_alternative_names   = ["*.${var.hosted_zone1}", var.hosted_zone1]
  wait_for_certificate_issued = true
  env                         = var.env

}


module "hosted_zone1_cert_dev" {
  source                      = "./certs"
  domain_name                 = var.hosted_zone1
  domain_validation_options   = "DNS"
  subject_alternative_names   = ["*.${var.env}.${var.hosted_zone1}", var.hosted_zone1]
  wait_for_certificate_issued = true
  dns_zone                    = var.hosted_zone1
  allow_overwrite             = false
  env                         = var.env
  depends_on                  = [module.hosted_zone1_cert]
}
