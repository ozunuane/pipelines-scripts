### PROD WORKSPACE SECRETS AND VARIABLES ###
variable "test_service_prod_env" {
  default = [
    {
      "name" : "SERVICE_NAME",
      "value" : "sv.user"
    },

    {
      "name" : "USER_SERVICE_PORT",
      "value" : "5000"
    },
    {
      "name" : "APP_ENV",
      "value" : "prod"
    },
  ]
}



variable "test_service_prod_secrets" {
  default = [

    {
      "valueFrom" : "/software/prod/mongo/database/name"
      "name" : "DATABASE_NAME"
    },

    {
      "valueFrom" : "/software/prod/mongo/database/url"
      "name" : "DATABASE_URL"
    }

  ]
}
