# ACM certificate has to be in us-east-1 in order to work with CloudFront
provider "aws" {
  region = "us-east-1"
}

# Hosted zone in Route53
resource "aws_route53_zone" "zone" {
  name = "${var.primary_domain}."
}
