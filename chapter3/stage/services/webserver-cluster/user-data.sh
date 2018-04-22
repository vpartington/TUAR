#!/bin/bash
echo "<html><body><h1>Hello World</h1>" > index.html
echo "<b>address:</b> ${db_address}<br/>" >> index.html
echo "<b>port:</b> ${db_port}<br/>" >> index.html
nohup busybox httpd -f -p ${webserver_port} &
