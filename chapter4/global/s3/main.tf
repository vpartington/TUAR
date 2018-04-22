provider "aws" {
  version = "~> 1.15"
  region = "us-east-2"
}

terraform {
  backend "s3" {
    region = "us-east-2"
    bucket = "tuar-state-for-vpartington"
    key = "global/s3/terraform.tfstate"
    encrypt = "true"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tuar-state-for-vpartington"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

}
