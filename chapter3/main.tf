provider "aws" {
  version = "~> 1.10"
  ]region = "us-east-2"
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
