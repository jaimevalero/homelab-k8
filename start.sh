#!/bin/bash

export KUBECONFIG=/etc/kubernetes/admin.conf

  kubeadm reset -f
  swapoff -a
  kubeadm init --pod-network-cidr=192.168.1.0/16
  kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

  kubectl taint nodes --all node-role.kubernetes.io/master-


  # PersistentVolume

   mkdir /mnt/data
   kubectl apply -f https://k8s.io/examples/pods/storage/pv-volume.yaml
   kubectl get pv task-pv-volume

  # EXTERNAL-IP 
   kubectl create -f metallb-config.yaml
   kubectl apply  -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
   kubectl get svc

