#!/bin/bash -xv
exec > /tmp/userdata.log 2>&1

# Add some swap so system does not run out of memory:
dd if=/dev/zero of=/swapfile bs=1G count=2
chmod 0600 /swapfile
mkswap /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
swapon -a

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y java-1.8.0-openjdk jenkins
systemctl start jenkins
sleep 5
systemctl status jenkins
