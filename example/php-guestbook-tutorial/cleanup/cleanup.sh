#!/bin/bash

if [[ 0 > 0 ]]
  then echo "Exiting... Please run as root"
  exit
fi

  kubectl delete deployment -l app=redis
  kubectl delete service -l app=redis
  kubectl delete deployment -l app=guestbook
  kubectl delete service -l app=guestbook

