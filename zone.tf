# ACM certificate has to be in us-east-1 in order to work with CloudFront
provider "aws" {
  region = "us-east-1"
}

# Hosted zone in Route53
resource "aws_route53_zone" "zone" {
  name = "${var.primary_domain}."
}

# Primary domain DNS record
resource "aws_route53_record" "primary_domain" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "${var.primary_domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.primary_domain.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.primary_domain.hosted_zone_id}"
    evaluate_target_health = false
  }
}

# Secondary domain DNS record
resource "aws_route53_record" "secondary_domain" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "${var.secondary_domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.secondary_domain.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.secondary_domain.hosted_zone_id}"
    evaluate_target_health = false
  }
}
