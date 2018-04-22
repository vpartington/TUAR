variable "env_name" {
  description = "Name of environment, e.g. stage or prod"
}

variable "instance_type" {
  description = "Type of EC2 instance to use, e.g. t2.micro"
  default = "t2.micro"
}

variable "min_size" {
  description = "Minimum number of EC2 instances in ASG"
  default = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in ASG"
  default = 10
}

variable "webserver_port" {
  description = "Port to use for the webserver"
  default = 8282
}
