## About this Module
This Terraform module creates n-number of AWS subnets depending on the size of map object provided. The following variables are required to run this module:
* env: the environment the subnet(s) belongs to
* vpc_id: the VPC ID the subnets belongs to
* networks: A map variable providing a list of the IP addresses for the subnets example variable declaration for this module is:
``` variable "networks" {
  type = map(any)
  default = {
    rds = {
      subnets = ["x.x.x.x/22", "x.x.x.x/22"]
      is_public = true
    }
    ecs = {
      subnets = ["x.x.x.x/22", "x.x.x.x/22", "x.x.x.x/22"]
      is_public = false
    }
  }
}
```
With the above map variables, this module will create two public subnets and three private subnets, all in three availability zones, a, b, or c (can create up to az g!) with a name tag of `moni-staging-public-sn-1`, `moni-staging-public-sn-2` `moni-staging-private-sn-1`, `moni-staging-private-sn-2`, and `moni-staging-private-sn-3`

