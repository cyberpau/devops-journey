#!/bin/bash

if [[ 0 > 0 ]]
  then echo "Exiting... Please run as root"
  exit
fi

kubectl delete service nginx

kubectl delete statefulset web

