resource "aws_network_acl" "nacl" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  tags = {
    "Environment" = "${var.env}"
    "Name"        = "${var.name}-${var.env}-nacl"
  }
}



############ ACL RULES ###########
resource "aws_network_acl_rule" "nacl_rule" {
  for_each       = var.nacl_rules
  network_acl_id = aws_network_acl.nacl.id
  egress         = each.value.rule[6] == "egress" ? true : false
  rule_number    = each.value.rule[5]
  rule_action    = each.value.rule[0]
  protocol       = each.value.rule[4]
  from_port      = each.value.rule[2]
  to_port        = each.value.rule[3]
  cidr_block     = each.value.rule[1]
}



