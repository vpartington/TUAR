provider "aws" {
  region = "eu-west-2"
}

variable "webserver_port" {
  description = "Port to use for the webserver"
  default = 8282
}

output "webserver_ip" {
  value = "${aws_instance.webserver.public_ip}"
}

resource "aws_instance" "webserver" {
  ami = "ami-941e04f0"
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
