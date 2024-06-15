variable "app_name" {
  description = "An optional name to override the name of the resources created."
}

variable "project" {
  description = "The Project our resources are associated with"
}

variable "project_service" {
  description = "The ID of the associated billing account (optional)."
}

variable "gcp_project_id" {
  description = "The id of the Google Cloud Project."
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

variable "domain" {
  description = "The domain used for the application. Used to generate an SSL certificate and associates CNAMEs."
}
