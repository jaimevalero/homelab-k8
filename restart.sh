#!/bin/bash

# Restart cluster

  export KUBECONFIG=/etc/kubernetes/admin.conf
  # Stop
  kubeadm reset -f
  swapoff -a

  # Clean env
  docker container prune --filter "until=24h"   -f 
  docker volume    prune --filter "label!=keep" -f 
  docker network   prune                        -f 
 
 # net config
  kubeadm init --pod-network-cidr=192.168.1.0/16
  kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

  # taint
  kubectl taint nodes --all node-role.kubernetes.io/master-


  # PersistentVolume

   mkdir /mnt/data
   kubectl apply -f https://k8s.io/examples/pods/storage/pv-volume.yaml
   kubectl get pv task-pv-volume

  # EXTERNAL-IP, create pool
   kubectl create -f metallb-config.yaml
   kubectl apply  -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
   kubectl get svc

  # Kubernetes dashboard - permissions
    kubectl apply -f recommended.yaml 
    kubectl create serviceaccount kubernetes-dashboard
    kubectl delete clusterrolebinding kubernetes-dashboard
    kubectl create clusterrolebinding kubernetes-dashboard  --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:kubernetes-dashboard

  # Proxy
  kubectl proxy --address="192.168.1.64" -p 8001 --accept-hosts='^*$' 
