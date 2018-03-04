provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "first" {
  ami = "ami-403e2524"
  instance_type = "t2.micro"

  tags {
    Name = "Created by vpartington with terraform"
  }
}
