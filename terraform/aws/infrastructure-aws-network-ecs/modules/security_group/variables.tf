variable "rules" {
  type = map(object({
    from_port          = number
    to_port            = number
    protocol           = string
    allowed_cidr_block = string
  }))
  default = {}
}



variable "env" {
}

variable "name" {
}

variable "vpc_id" {

}



variable "description" {
  default = "managed with terraform"
}

