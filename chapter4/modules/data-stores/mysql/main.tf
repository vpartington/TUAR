provider "aws" {
  version = "~> 1.15"
  region = "us-east-2"
}

resource "aws_db_instance" "mysql" {
  identifier = "${var.env_name}-mysql-db-created-by-vpartington"

  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "emp"
  username = "admin"
  password = "${var.db_password}"

  final_snapshot_identifier = "${var.env_name}-db-snapshot-created-by-vpartington"

}
