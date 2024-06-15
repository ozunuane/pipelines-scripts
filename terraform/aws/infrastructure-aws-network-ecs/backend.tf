


# terraform {
#   backend "local" {
#     path = "default.state" # Path to your local state file
#   }

# }

terraform {
  backend "s3" {
    encrypt = true
  }
}




