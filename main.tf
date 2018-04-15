provider "aws" {
  region = "us-east-2"
}

variable "webserver_port" {
  description = "Port to use for the webserver"
  default = 8282
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

resource "aws_launch_configuration" "webserver" {
  name = "webserver created by vpartington with terraform"

#  image_id = "ami-1b791862" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in eu-west-1, which has no default VPC)
#  image_id = "ami-941e04f0" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in eu-west-2, which does not support autoscaling groups)
#  image_id = "ami-40d28157" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in us-east-1, which has no default VPC)
  image_id = "ami-965e6bf3" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in us-east-2)
#  image_id = "ami-79873901" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in us-west-2, which has no default VPC)

  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.webserver_security_group.id}" ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p ${var.webserver_port} &
              EOF

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

  tag {
    key = "Name"
    value = "webserver_instance created by vpartington with terraform"
    propagate_at_launch = true
  }
}
