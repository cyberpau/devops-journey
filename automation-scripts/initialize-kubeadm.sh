#!/bin/bash
# Authored by John Paulo Mataac

if [[ 0 > 0 ]]
  then echo "Exiting... Please run as root"
  exit
fi

systemctl disable firewalld
systemctl stop firewalld

kubeadm init

mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
sudo chown 0:0 /root/.kube/config


# Configure network overlay using Flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
