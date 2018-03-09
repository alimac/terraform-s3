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

If AWS is not your domain registrar, you will need to set your domain's name servers
to AWS name servers associated with your hosted zone. Terraform will output those
automatically:

```
Outputs:

name_servers = [
    ns-1500.awsdns-59.org,
    ns-1595.awsdns-07.co.uk,
    ns-619.awsdns-13.net,
    ns-63.awsdns-07.com
]
```
