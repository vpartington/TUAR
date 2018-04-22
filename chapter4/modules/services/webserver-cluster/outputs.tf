output "webserver_elb_dns_name" {
  value = "${aws_elb.webserver_elb.dns_name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.webserver_group.name}"
}
