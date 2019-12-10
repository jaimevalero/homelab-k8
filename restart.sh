#!/bin/bash

# Restart cluster

  export KUBECONFIG=/etc/kubernetes/admin.conf
  # Stop
  kubeadm reset -f
  swapoff -a
 
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

