# Terraform for S3 Static Website

This is a set of Terraform files to set up a static website in AWS. It makes use of the following resources:

- S3
- Route53
- CloudFront
- Certificate Manager

The end result is a website that supports:

- a primary and secondary domain (typically apex and www domains)
- HTTPS
- redirect from secondary to primary

## Usage

1. Install Terraform
1. Configure your AWS profile
1. `git clone git@github.com:alimac/terraform-s3-static-website.git`
1. `cd terraform-s3-static-website`
1. `terraform apply`

You will be prompted to provide values for primary and secondary domain.

In addition to typing values at the prompt, you can create a `terraform.tfvars` file:

```
primary_domain = "example.com"
secondary_domain = "www.example.com"
```
