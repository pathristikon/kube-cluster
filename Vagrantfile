# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|
  config.vm.provision "shell", path: "bootstrap/bootstrap.sh"
  config.vm.synced_folder "config/", "/vagrant"

  config.vm.define "on-demand" do |node|
    node.vm.box               = "generic/ubuntu2004"
    node.vm.box_check_update  = false
    node.vm.box_version       = "3.3.0"
    node.vm.hostname          = "on-demand.example.com"
    node.vm.network "public_network", bridge: "en7: USB 10/100/1000 LAN", ip: "192.168.100.100"

    node.vm.provider :virtualbox do |v|
      v.name    = "on-demand"
      v.memory  = 2048
      v.cpus    =  2
    end
  
    node.vm.provider :libvirt do |v|
      v.memory  = 2048
      v.nested  = true
      v.cpus    = 2
    end
  
    node.vm.provision "shell", path: "bootstrap/master-bootstrap.sh", privileged: true
  end

  ExtraMasters = 2
  (1..ExtraMasters).each do |i|
    config.vm.define "on-demand#{i}" do |node|
      node.vm.box               = "generic/ubuntu2004"
      node.vm.box_check_update  = false
      node.vm.box_version       = "3.3.0"
      node.vm.hostname          = "on-demand#{i}.example.com"

      node.vm.network "public_network", bridge: "en7: USB 10/100/1000 LAN", ip: "192.168.100.10#{i}"

      node.vm.provider :virtualbox do |v|
        v.name    = "on-demand#{i}"
        v.memory  = 2048
        v.cpus    = 2
      end

      node.vm.provider :libvirt do |v|
        v.memory  = 2048
        v.nested  = true
        v.cpus    = 2
      end

      node.vm.provision "shell", path: "config/.kube/controlplane-joincluster.sh", privileged: true
    end
  end

  NodeCount = 2
  (1..NodeCount).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box               = "generic/ubuntu2004"
      node.vm.box_check_update  = false
      node.vm.box_version       = "3.3.0"
      node.vm.hostname          = "node#{i}.example.com"

      node.vm.network "public_network", bridge: "en7: USB 10/100/1000 LAN", ip: "192.168.100.11#{i}"

      node.vm.provider :virtualbox do |v|
        v.name    = "node#{i}"
        v.memory  = 1024
        v.cpus    = 1
      end

      node.vm.provider :libvirt do |v|
        v.memory  = 1024
        v.nested  = true
        v.cpus    = 1
      end

      node.vm.provision "shell", path: "bootstrap/worker-bootstrap.sh"
    end
  end
end
