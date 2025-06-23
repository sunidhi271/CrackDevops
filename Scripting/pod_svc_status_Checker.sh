#!/bin/bash

pod=$1
svc=$2
namespace=$3
kubectl get ${pod} -n ${namespace} > /dev/null 2>&1   #send both stdout and stderr to /dev/null
if [ $? -eq 0 ]; then                                 #$? is the exit code
  POD_STATUS=$(kubectl get ${pod} -n ${namespace} -o jsonpath="{.status.phase}")
  echo "${pod} is deployed and it is in ${POD_STATUS} phase"
else
  echo "${pod} is not deployed."
fi

kubectl get ${svc} -n ${namespace} > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "${svc} is deployed"
else
  echo "${svc} is not deployed"
fi
