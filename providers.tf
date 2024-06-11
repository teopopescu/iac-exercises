terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 1.0.10"
    }
  }
}



########################## Default region ##########################
provider "aws" {
  region = "eu-west-2"
}

########################## Store Terraform state file into S3 bucket ##########################
terraform {
  backend "s3" {
    bucket         = "tf-test-bucket"  # CREATE FIRST MANUALLY
    key            = "test-key"
    region         = "eu-west-2"
  }
}

########################## aws_region ##########################
data "aws_region" "current" {}

########################## aws_availability_zones ##########################
data "aws_availability_zones" "available" {
  state = "available"
}
