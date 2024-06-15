variable "app_name" {
  description = "An optional name to override the name of the resources created."
}

variable "region" {
  description = "The GCP region to deploy resourcess"
}

variable "gcp_project_id" {
  description = "The GCP region to deploy resources"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}
