terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = ">=5.0.0"
    }
    awscc = {
      source = "hashicorp/awscc"
      # version = ">= 0.57.0"
    }
  }
}

# Configure the AWS and AWSCC Providers
provider "aws" {
  region = var.aws_region
}
provider "awscc" {
  region = var.aws_region
}
