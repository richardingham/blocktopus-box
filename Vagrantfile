# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 2
    end

    config.vm.box = "ubuntu/xenial64"
    config.vm.network "private_network", ip: "192.168.33.12"
    config.vm.hostname = "octopus-box"

    config.vm.provision :shell, path: "provision.sh"
end
