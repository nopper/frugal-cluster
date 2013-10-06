# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "frugal"

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.manifest_file  = "frugal.pp"
     puppet.module_path = "modules"
  end

  # This is the master
  config.vm.define :node0 do |node|
    node.vm.network "private_network", ip: "10.31.33.70"
    node.vm.hostname = "node0"
    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.name = "node0"
    end
  end

  config.vm.define :node1 do |node|
    node.vm.network "private_network", ip: "10.31.33.71"
    node.vm.hostname = "node1"
    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.name = "node1"
    end
  end

  config.vm.define :node2 do |node|
    node.vm.network "private_network", ip: "10.31.33.72"
    node.vm.hostname = "node2"
    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.name = "node2"
    end
  end

  config.vm.define :node3 do |node|
    node.vm.network "private_network", ip: "10.31.33.73"
    node.vm.hostname = "node3"
    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.name = "node3"
    end
  end

end
