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

Enjoy :)