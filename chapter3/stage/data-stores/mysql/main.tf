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

resource "aws_db_instance" "mysql" {
  identifier = "mysql-db-created-by-vpartington"

  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "emp"
  username = "admin"
  password = "${var.db_password}"

  final_snapshot_identifier = "db-snapshot-created-by-vpartington"

}
