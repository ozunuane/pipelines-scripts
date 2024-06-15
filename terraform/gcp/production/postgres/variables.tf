variable "app_name" {
  description = "An optional name to override the name of the resources created."
}

variable "project" {
  description = "The Project our resources are associated with"
}

variable "project_service" {
  description = "The ID of the associated billing account (optional)."
}

variable "network" {
  description = "The Virtual network  where our resources will be deployed"
}

variable "private_subnet" {
  description = "The private subnet in our virtual network"
}

variable "public_subnet" {
  description = "The private subnet in our vpc"
}

variable "region" {
  description = "The region where to host Google Cloud Organization resources."
}

variable "authorized_networks" {
  description = "A list of authorized CIDR-formatted IP address ranges that can connect to this DB. Only applies to public IP instances."
}

variable "postgres_tier" {
  description = "The instance type to use for Postgres."
  type        = string
}

# locals {
#   postgres_instances = {
#   }
# }
