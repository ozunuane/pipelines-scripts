output "terraform_bucket_name" {
  value = aws_s3_bucket.tf_bucket.id
}
output "terraform_dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock.id
}
