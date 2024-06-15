resource "aws_ecr_repository" "ecr" {
  for_each = { for idx, name in var.ecr_repo : idx => name }

  name                 = each.key
  image_tag_mutability = each.value.image_tag_mutability ? "MUTABLE" : "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = each.value.image_scan_on_push
  }
  encryption_configuration {
    encryption_type = each.value.encryption_type == "KMS" ? "KMS" : "AES256"
  }

  tags = {
    Name        = "${each.key}-${var.env}"
    Environment = "${var.env}"
  }
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  for_each = { for k, v in var.ecr_repo : k => v if v.attach_repository_policy }

  repository = aws_ecr_repository.ecr[each.key].name
  policy     = <<EOF
{
    "Statement": [
        {
            "Sid": "ecr policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}




resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  for_each = { for k, v in var.ecr_repo : k => v if v.create_lifecycle_policy }

  repository = aws_ecr_repository.ecr[each.key].name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last ${lookup(each.value.lifecycle_policy, "countNumber", 90)} images",
      "selection": {
        "tagStatus": "${lookup(each.value.lifecycle_policy, "tagStatus", "any")}",
        "tagPrefixList": ["${lookup(each.value.lifecycle_policy, "tagPrefixList", "test")}"],
        "countType": "${lookup(each.value.lifecycle_policy, "countType", "imageCountMoreThan")}",
        "countNumber": "${lookup(each.value.lifecycle_policy, "countNumber", 90)}"
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}


