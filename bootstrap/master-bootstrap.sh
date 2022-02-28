#!/bin/bash

echo "[TASK 0] Cleanup"
sudo rm -rf /vagrant/.kube

echo "[TASK 1] Prepare haproxy"
apt install -y haproxy
rm -rf /etc/haproxy/haproxy.cfg && cp /vagrant/haproxy.cfg /etc/haproxy/haproxy.cfg
systemctl restart haproxy

echo "[TASK 2] Pull required containers"
kubeadm config images pull >/dev/null 2>&1
sudo mkdir -p /vagrant/.kube

echo "[TASK 3] Initialize Kubernetes Cluster"
# --upload-certs to secrets so that the new masters can take them. Or move the certs manually
kubeadm init --control-plane-endpoint="192.168.56.2:6444" --upload-certs --apiserver-advertise-address=192.168.56.2 --pod-network-cidr=192.168.0.0/16 >> /vagrant/.kube/kubeinit.log 2>/dev/null

echo "[TASK 4] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 5] Generate and save cluster join command to /vagrant/joincluster.sh"
kubeadm token create --print-join-command > /vagrant/.kube/joincluster.sh 2>/dev/null

echo "[TASK 6] Prepare Kubeconfig file"
sudo cp -R /etc/kubernetes/admin.conf /vagrant/.kube/config