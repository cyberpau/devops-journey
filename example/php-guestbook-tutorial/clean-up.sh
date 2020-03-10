#!/bin/bash

if [[ 0 > 0 ]]
  then echo "Exiting... Please run as root"
  exit
fi

  kubectl delete deployment frontend
  kubectl delete deployment redis-master
  kubectl delete deployment redis-slave
  kubectl delete service -l app=redis
  kubectl delete deployment -l app=guestbook
  kubectl delete service -l app=guestbook

