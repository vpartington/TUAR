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
    key = "stage/services/webserver-cluster/terraform.tfstate"
    encrypt = "true"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config {
    region = "us-east-2"
    bucket = "tuar-state-for-vpartington"
    key = "stage/data-stores/mysql/terraform.tfstate"
  }
}

resource "aws_security_group" "webserver_security_group" {
  name = "webserver_security_group created by vpartington with terraform"

  ingress {
    from_port = "${var.webserver_port}"
    to_port = "${var.webserver_port}"
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"

  vars {
    webserver_port = "${var.webserver_port}"
    db_address = "${data.terraform_remote_state.db.address}"
    db_port = "${data.terraform_remote_state.db.port}"
  }
}
resource "aws_launch_configuration" "webserver" {
  name = "webserver created by vpartington with terraform"

  image_id = "ami-965e6bf3" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in us-east-2)

  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.webserver_security_group.id}" ]
  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" { }

resource "aws_autoscaling_group" "webserver_group" {
  name = "webserver_group created by vpartington with terraform"

  launch_configuration = "${aws_launch_configuration.webserver.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  min_size = 2
  max_size = 10
  desired_capacity = 4
  load_balancers = ["${aws_elb.webserver_elb.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "webserver_instance created by vpartington with terraform"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "webserver_elb_security_group" {
  name = "webserver_elb_security_group created by vpartington with terraform"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

}

resource "aws_elb" "webserver_elb" {
  name = "webserverelbbyvpartington"

  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.webserver_elb_security_group.id}"]

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.webserver_port}"
    instance_protocol = "http"

  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.webserver_port}/"
  }
}
