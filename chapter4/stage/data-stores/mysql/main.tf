provider "aws" {
  version = "~> 1.15"
  region = "us-east-2"
}

terraform {
  backend "s3" {
    region = "us-east-2"
    bucket = "tuar-state-for-vpartington"
    key = "stage/data-stores/mysql/terraform.tfstate"
    encrypt = "true"
  }
}

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  env_name = "stage"
  db_password = "${var.db_password}"
}
