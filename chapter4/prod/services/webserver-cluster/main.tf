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

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  autoscaling_group_name = "${module.webserver-cluster.asg_name}"

  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 4
  max_size = 10
  desired_capacity = 10

  recurrence = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  autoscaling_group_name = "${module.webserver-cluster.asg_name}"

  scheduled_action_name = "scale-in-at-night"
  min_size = 4
  max_size = 10
  desired_capacity = 4

  recurrence = "0 17 * * *"
}
