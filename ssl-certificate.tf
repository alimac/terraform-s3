# SSL certificate covering primary and secondary domains
resource "aws_acm_certificate" "cert" {
  domain_name = "${var.primary_domain}"
  validation_method = "DNS"

  subject_alternative_names = ["${var.secondary_domain}"]

  tags {
    Name = "${var.primary_domain}"
  }
}

# Domain validation record - primary domain
resource "aws_route53_record" "primary_validation" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
}

# Domain validation record - secondary domain
resource "aws_route53_record" "secondary_validation" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
}

# Wait for domain validation to complete
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.primary_validation.fqdn}",
    "${aws_route53_record.secondary_validation.fqdn}"
  ]
}
