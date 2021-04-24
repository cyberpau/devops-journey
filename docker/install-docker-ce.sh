#!/bin/bash
# Authored by John Paulo Mataac

if [[ $EUID > 0 ]]
  then echo "Exiting... Please run as root"
  exit
fi

sudo yum install -y yum-utils

sudo yum-confi-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Optional: Enable the nightly or test repositories.
# sudo yum-config-manager --enable docker-ce-nightly

sudo yum install -y docker-ce docker-ce-cli containerd.io 

sudo systemctl start docker

