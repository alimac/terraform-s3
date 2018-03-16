# Origin access identity that CloudFront will use
resource "aws_cloudfront_origin_access_identity" "primary_domain" {}

# Policy that allows CloudFront to access content bucket
data "aws_iam_policy_document" "primary_domain" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.primary_domain}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.primary_domain.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.primary_domain}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.primary_domain.iam_arn}"]
    }
  }
}

# S3 bucket for hosting static website
resource "aws_s3_bucket" "primary_domain" {
  bucket = "${var.primary_domain}"
  policy = "${data.aws_iam_policy_document.primary_domain.json}"

  website {
    index_document = "index.html"
  }
}

# S3 bucket for redirection
resource "aws_s3_bucket" "secondary_domain" {
  bucket = "${var.secondary_domain}"

  website {
    redirect_all_requests_to = "https://${var.primary_domain}"
  }
}

# Hello, world HTML file
resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${aws_s3_bucket.primary_domain.id}"
  key          = "index.html"
  source       = "index.html"
  acl          = "private"
  content_type = "text/html"
}
