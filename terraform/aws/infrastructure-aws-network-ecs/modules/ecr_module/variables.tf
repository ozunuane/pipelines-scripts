
variable "env" {
  default = "staging"
}

variable "ecr_repo" {
  type = map(any)
  default = {
    reposit1 = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "AES256"
      attach_repository_policy = false
      create_lifecycle_policy  = true
      lifecycle_policy = {
        tagStatus     = "tagged"
        countType     = "imageCountMoreThan"
        countNumber   = 90
        tagPrefixList = "test"
      }
    }
    repo2 = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "KMS"
      attach_repository_policy = true
      create_lifecycle_policy  = true
      lifecycle_policy = {
        tagStatus = "any"
        countType = "imageCountMoreThan"
      }
    }
  }
}







