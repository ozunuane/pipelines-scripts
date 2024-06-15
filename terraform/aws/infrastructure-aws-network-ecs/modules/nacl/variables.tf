variable "nacl_rules" {
  type = map(any)
  default = {
    rule1 = {
      "rule" = ["allow", "ip", "from", "to", "protocol", "rule_number", "rule_dir"]
    }
    rule2 = {
      "rule" = ["allow", "ip", "from", "to", "protocol", "rule_number", "rule_dir"]
    }
  }
}


# variable "nacl_rules" {
#   description = "The list of rules for the network ACL"
#   type        = list(object({
#     rule = list(string)
#   }))
# }


variable "env" {
}

variable "vpc_id" {
}


variable "subnet_ids" {
}
variable "name" {

}