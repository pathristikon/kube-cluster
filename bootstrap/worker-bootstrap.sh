#!/bin/bash

echo "[TASK 1] Join node to Kubernetes Cluster"
bash /vagrant/.kube/joincluster.sh > /dev/null 2>&1

cp -R /vagrant/.kube /home/vagrant/.kube
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
