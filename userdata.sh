#!/bin/bash -xv
exec > /tmp/userdata.log 2>&1

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y java-1.8.0-openjdk jenkins
systemctl start jenkins
sleep 5
systemctl status jenkins
