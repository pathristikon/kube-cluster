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
kubeadm init --control-plane-endpoint="on-demand.example.com:6444" --upload-certs --apiserver-advertise-address=192.168.100.100 --pod-network-cidr=192.168.0.0/16 >> /vagrant/.kube/kubeinit.log 2>/dev/null

echo "[TASK 4] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 5] Generate and save cluster join command to /vagrant/joincluster.sh"
kubeadm token create --print-join-command > /vagrant/.kube/joincluster.sh 2>/dev/null

# set IP address to command
# parse the kubeinit.log file, remove trailing slashes and spaces and append --apiserver-advertise-address at the end of the file
cat /vagrant/.kube/kubeinit.log | grep -B 2 '\--control-plane' | tr -d '\n' | sed 's/\\//g' > /vagrant/.kube/controlplane-joincluster.sh 2>/dev/null
echo $' --apiserver-advertise-address=$(/sbin/ifconfig eth1 | grep inet | awk \'{print $2}\')' >> /vagrant/.kube/controlplane-joincluster.sh

echo "[TASK 6] Prepare Kubeconfig file"
sudo cp -R /etc/kubernetes/admin.conf /vagrant/.kube/config
