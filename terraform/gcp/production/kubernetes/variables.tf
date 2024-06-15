variable "app_name" {
  description = "An optional name to override the name of the resources created."
}

variable "project" {
  description = "The Project our resources are associated with"
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

variable "k8_node_instance_type" {
  description = "The compute instance type to use for Kubernetes nodes."
  type        = string
}

variable "k8_spot_instance_percent" {
  description = "The percentage of spot instances to use for Kubernetes nodes."
  type        = number
}

variable "k8_min_node_count" {
  description = "The minimum number of nodes to run in the Kubernetes cluster."
  type        = number
}

variable "k8_max_node_count" {
  description = "The maximum number of nodes to run in the Kubernetes cluster."
  type        = number
}

variable "authorized_networks" {
  description = "A list of authorized CIDR-formatted IP address ranges that can connect to this DB. Only applies to public IP instances."
  type        = list(map(string))
  default     = []
}
