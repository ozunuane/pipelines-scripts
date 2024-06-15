variable "organization" {
  description = "The name of the organization"
  type = string
  default = "Africa Fintech Limited"
}

variable "app_name" {
  description = "Name of Application"
  default = "naijapay"
}

variable "region" {
  description = "The region where to host Google Cloud Organization resources."
  default = "europe-west2"
}

variable "region_zone" {
  description = "The zone in the region where to host Google Cloud Organization resources."
  default = "europe-west2-a"
}

variable "region_zone_backup" {
  description = "The backup zone in the region where to host Google Cloud Organization resources."
  default = "europe-west2-b"
}

variable "gcp_project_id" {
  description = "The id of the Google Cloud Project."

}

variable "gcp_private_key_id" {
  description = "The id of the private key for the service account."
}

variable "gcp_private_key" {
  description = "The private key for the service account."
}

variable "gcp_client_email" {
  description = "The client email for the service account."
}

variable "gcp_client_id" {
  description = "The client id for the service account."
}

variable "gcp_client_x509_cert_url" {
  description = "The client certificate url for the service account."
}

variable "cloudflare_dns_api_token" {
  description = "Cloudflare DNS API token for SSL certificate creation and verification."
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone id to set CNAMEs."
}

variable "domain" {
  description = "The domain used for the application. Used to generate an SSL certificate and associates CNAMEs."
}

variable "vpc_cidr" {
  description = "CIDR for the VPC."
  default     = "10.0.0.0/16"
}


variable "authorized_networks" {
  description = "A list of authorized CIDR-formatted IP address ranges that can connect to this DB. Only applies to public IP instances."
  type        = list(map(string))
  default     = []
}

variable "ip_whitelist" {
  description = "An optional list of IP addresses to whitelist access to for microservices with private acl."
  type        = string
  default     = ""
}

variable "ssh_whitelist" {
  description = "An optional list of IP addresses to whitelist ssh access."
  type        = string
  default     = ""
}

variable "k8_node_instance_type" {
  description = "The compute instance type to use for Kubernetes nodes."
  type        = string
  default     = "e2-standard-4"
}
variable "k8_spot_instance_percent" {
  description = "The percentage of spot instances to use for Kubernetes nodes."
  type        = number
  default     = 50
  validation {
    condition     = var.k8_spot_instance_percent >= 0 && var.k8_spot_instance_percent <= 100
    error_message = "Value must be between 0 - 100."
  }
}
variable "k8_min_node_count" {
  description = "The minimum number of nodes to run in the Kubernetes cluster."
  type        = number
  default     = 5
}
variable "k8_max_node_count" {
  description = "The maximum number of nodes to run in the Kubernetes cluster."
  type        = number
  default     = 100
}

variable "postgres_tier" {
  description = "The instance type to use for Postgres."
  type        = string
  default     = "db-f1-micro"
  # https://cloud.google.com/sql/docs/mysql/instance-settings#:~:text=see%20Instance%20Locations.-,Machine,-Type
}

locals {
  services ={
    cba ={}
    noncba= {}
  }

  ip_whitelist  = distinct([for value in split(",", var.ip_whitelist) : "${trimspace(value)}${replace(value, "/", "") != value ? "" : "/32"}" if trimspace(value) != ""])
  ssh_whitelist = distinct([for value in split(",", var.ssh_whitelist) : "${trimspace(value)}${replace(value, "/", "") != value ? "" : "/32"}" if trimspace(value) != ""])
}
