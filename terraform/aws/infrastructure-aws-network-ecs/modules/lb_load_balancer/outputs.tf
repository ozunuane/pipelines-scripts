output "lb_details" {
  value = local.lb_details
}

output "nlb_details" {
  value = local.nlb_details
}

output "lb_security_group_id" {
  value = module.lb_security_group[0].id
}