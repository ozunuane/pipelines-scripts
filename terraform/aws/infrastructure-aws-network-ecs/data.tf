####### DATA FROM GLOBAL RESOURCES #############

###### ROUTE53 DNS GLOBAL ###################3#####

##### DNS HOSTED ZONE TEST  ######
data "terraform_remote_state" "test_dns" {
  backend = "s3"
  config = {
    bucket = "terraform-states-fortnoto"
    key    = "infrastructure/global/terraform.tfstate"
    region = "us-east-1"
  }
}

#########################################################