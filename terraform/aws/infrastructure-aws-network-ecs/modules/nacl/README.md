## About this Module
This terraform module creates one AWS network access list (nacl) and nacl rules. Depending on the variable it is initialized with, it can create unlimited number of rules for the created nacl.

### Variables required to run this module include:
* vpc_id: the vpc in which the nacl will be created
* env: the environment the nacl resource belongs to, it can be dev, staging, uat or production, default value is dev. This variable is used tagging the resource
* subnet_ids: a list of subnets to associate the nacl rules to.
* nacl_rules: a map variable. The map key indicates unique rule number (rule1, rule2, rule3, ...). The "rule" map value is a list with format ["allow","ip","from","to","protocol","rule_number", "rule_dir"]. The "allow" string indicates the rule action, the "ip" string indicates the rule cidr block, the "from" and "to" are integer values representing port range, the protocol specifies the rule protocol (valid value include "tcp", "http", "https", etc), the "rule_number" is an integer value representing the rule priority (lower rule_number value implies higher rule priority) while the "rule_dir" specifies the direction to apply the rule (only two values are allowed, "ingress" and "egress")
