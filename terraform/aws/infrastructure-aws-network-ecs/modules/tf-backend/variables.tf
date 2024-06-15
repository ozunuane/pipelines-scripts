variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
}



variable "tf_backend_iam_principals" {
  description = "AWS IAM principals identifiers"
  type        = list(string)
  default     = []
}

