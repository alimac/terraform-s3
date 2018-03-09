# S3 bucket for hosting static website
resource "aws_s3_bucket" "primary_domain" {
  bucket = "${var.primary_domain}"

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
  bucket = "${aws_s3_bucket.primary_domain.id}"
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}
