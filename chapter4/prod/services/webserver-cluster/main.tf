provider "aws" {
  version = "~> 1.15"
  region = "us-east-2"
}

provider "template" {
  version = "~> 1.0"
}

terraform {
  backend "s3" {
    region = "us-east-2"
    bucket = "tuar-state-for-vpartington"
    key = "prod/services/webserver-cluster/terraform.tfstate"
    encrypt = "true"
  }
}


module "webserver-cluster" {
  source = "../../../modules/services/webserver-cluster"

  env_name = "prod"
  instance_type = "m4.large"
  min_size = 4
  max_size = 10
}
