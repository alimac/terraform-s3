# CloudFront distribution - primary domain (S3 origin)
resource "aws_cloudfront_distribution" "primary_domain" {
  aliases             = ["${var.primary_domain}"]
  default_root_object = "index.html"
  enabled             = true
  price_class         = "PriceClass_100"

  origin {
    domain_name = "${aws_s3_bucket.primary_domain.bucket_domain_name}"
    origin_id   = "S3-${var.primary_domain}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.primary_domain.cloudfront_access_identity_path}"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cert.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "S3-${var.primary_domain}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  tags {
    Name = "${var.primary_domain}"
  }
}

# CloudFront distribution - secondary domain (Custom origin)
resource "aws_cloudfront_distribution" "secondary_domain" {
  aliases     = ["${var.secondary_domain}"]
  enabled     = true
  price_class = "PriceClass_100"

  origin {
    domain_name = "${aws_s3_bucket.secondary_domain.website_endpoint}"
    origin_id   = "S3-${var.secondary_domain}"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cert.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "S3-${var.secondary_domain}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  tags {
    Name = "${var.secondary_domain}"
  }
}
