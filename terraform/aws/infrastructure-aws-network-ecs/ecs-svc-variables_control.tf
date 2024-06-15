### CONTROL WORKSPACE SECRETS AND VARIABLES ###
variable "test_service_control_env" {
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
      "value" : "control"
    },
  ]
}


variable "test_service_control_secrets" {
  default = [

    {
      "valueFrom" : "/software/control/mongo/database/name"
      "name" : "DATABASE_NAME"
    },

    {
      "valueFrom" : "/software/control/mongo/database/url"
      "name" : "DATABASE_URL"
    }

  ]
}
