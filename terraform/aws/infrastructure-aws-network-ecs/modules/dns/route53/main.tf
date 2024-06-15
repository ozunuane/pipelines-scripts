resource "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zones
  tags = {
    "Environment" = "${var.env}"
  }
}