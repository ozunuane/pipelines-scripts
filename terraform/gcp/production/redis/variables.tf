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
  description = "The public subnet in our vpc"
}

variable "region" {
  description = "The region where to host Google Cloud Organization resources."
}

variable "region_zone" {
  description = "The zone in the region where to host Google Cloud Organization resources."
}

variable "region_zone_backup" {
  description = "The backup zone in the region where to host Google Cloud Organization resources."
}

