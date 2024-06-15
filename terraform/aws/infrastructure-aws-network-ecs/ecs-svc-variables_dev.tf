### DEV WORKSPACE SECRETS AND VARIABLES ###

variable "test_service_dev_env" {
  default = [
    # {
    #   "name" : "SERVICE_NAME",
    #   "value" : "sv.user"
    # },

    # {
    #   "name" : "USER_SERVICE_PORT",
    #   "value" : "5000"
    # },
    # {
    #   "name" : "APP_ENV",
    #   "value" : "dev"
    # },
  ]
}



variable "test_service_dev_secrets" {
  default = [

    # {
    #   "valueFrom" : "/software/staging/mongo/database/name"
    #   "name" : "DATABASE_NAME"
    # },

    # {
    #   "valueFrom" : "/software/staging/mongo/database/url"
    #   "name" : "DATABASE_URL"
    # }

  ]
}
