#!/bin/bash
# Authored by John Paulo Mataac

if [[ $EUID > 0 ]]
  then echo "Exiting... Please run as root"
  exit
fi

### Download 
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
  
### install and set path
sudo install minikube /usr/bin/

### start minikube
minikube start --vm-driver=none

### Finally, check status
minikube status