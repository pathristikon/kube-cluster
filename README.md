### Requirements

- vagrant
- virtualbox

### Installation
``` /bin/sh
vagrant up
```

After the machines were provisioned, you will find in the folder data the following files:

- `config` - is the config for kube. You can put in any ~/.kube/config to access the cluster
- `joincluster.sh` - a bash script containing the command to join any worker in the cluster. Token valid for 24h.

To use the kubectl in any VM use the following commands:
```
vagrant ssh on-demand
mkdir -p .kube
cp -R /vagrant/config .kube/config

kubectl version
```

### Install metallb
```
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -f /vagrant/metallb.yaml
```

### Ingress Nginx Controller

```/bin/bash
kubectl apply -f /vagrant/nginx-ingress.yaml
```
The nginx ingress is modified to get the public ip from metallb. You can check it out using:

```/bin/bash
kubectl get svc -A
```

### Goodies

#### Change ip of the cluster API
https://blog.scottlowe.org/2019/07/30/adding-a-name-to-kubernetes-api-server-certificate/


### Setup internet access on nodes
https://github.com/connectbaseer/vagrant-centos-k8s-ha-cluster
https://betterprogramming.pub/how-to-expose-your-services-with-kubernetes-ingress-7f34eb6c9b5a
Enjoy :)