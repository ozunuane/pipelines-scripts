variable "routes" {
  type = map(any)
  default = {
    route1 = {
      "route" = ["0.0.0.0/0", "internet_gw"]
    }
  }
}

variable "gateways" {
  type    = list(string)
  default = ["i-skfkdj:transit_gw", "vg-i9iui:nat_gw"]
}

variable "env" {
  default = "dev"
}

variable "name" {

}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet_list"]

}

variable "vpc_id" {

}

variable "is_public" {
  default = false

}

variable "route_table_name" {
  default = "default"
}