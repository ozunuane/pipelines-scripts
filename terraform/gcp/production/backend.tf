terraform {
  required_version = "= 1.2.4"

  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.2.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    tls      = "~> 3.1.0"
    random   = "~> 3.1.0"
    null     = "~> 3.1.0"
    external = "~> 2.2.0"
    http     = "~> 2.1.0"
    local    = "~> 2.1.0"
  }

#   backend "gcs" {
#    bucket  = "9jaPay-app"
#    prefix  = "terraform/state"
#  }

    backend "local" {
      path = "terraform.tfstate"
    }
}
