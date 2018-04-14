provider "aws" {
  region = "us-east-2"
}

variable "webserver_port" {
  description = "Port to use for the webserver"
  default = 8282
}

output "webserver_ip" {
  value = "${aws_instance.webserver.public_ip}"
}

resource "aws_instance" "webserver" {
#  ami = "ami-1b791862" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in eu-west-1, which has no default VPC)
#  ami = "ami-941e04f0" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in eu-west-2, which does not support autoscaling groups)
#  ami = "ami-40d28157" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in us-east-1, which has no default VPC)
  ami = "ami-965e6bf3" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in us-east-2)
#  ami = "ami-79873901" # (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126 in us-west-2, which has no default VPC)

  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.webserver_security_group.id}" ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p ${var.webserver_port} &
              EOF

  tags {
    Name = "Created by vpartington with terraform"
  }
}

resource "aws_security_group" "webserver_security_group" {
  name = "terraform-example-instance"
  ingress {
    from_port = "${var.webserver_port}"
    to_port = "${var.webserver_port}"
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
