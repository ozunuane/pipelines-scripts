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

variable "region" {
  description = "The region where to host Google Cloud Organization resources."
}


variable "ssh_whitelist" {
  description = "An optional list of IP addresses to whitelist ssh access."
  type        = list(string)
}


variable "cba_cluster" {
  description = "CBA Kubernetes Cluster where cba services will be deployed"
}

variable "noncba_cluster" {
  description = "NonCBA Kubernetes Cluster where noncba services will be deployed"
}


