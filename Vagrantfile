# coding: utf-8
# copyright Utrecht University
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configuration variables.
VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] = "libvirt"

BOX = 'generic/ubuntu2004'
GUI = false
CPU = 2
RAM = 2048

DOMAIN  = ".ckan.test"
NETWORK = "192.168.60."
NETMASK = "255.255.255.0"
HOSTS = {
  "cd2" => [NETWORK+"30", 2, 2048, GUI, BOX],
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false

  HOSTS.each do | (name, cfg) |
    ipaddr, cpu, ram, gui, box = cfg

    config.vm.define name do |machine|
      machine.vm.box = box

      machine.vm.provider "virtualbox" do |vbox|
        vbox.gui    = gui
        vbox.cpus   = cpu
        vbox.memory = ram
        vbox.name   = name
        vbox.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
      end

      machine.vm.provider :libvirt do |libvirt|
        libvirt.driver = "kvm"
        libvirt.cpus   = cpu
        libvirt.memory = ram
      end

      machine.vm.hostname = name + DOMAIN
      machine.vm.network 'private_network', ip: ipaddr, netmask: NETMASK
      machine.vm.synced_folder ".", "/vagrant", disabled: true
      machine.vm.provision "shell",
        inline: "sudo timedatectl set-timezone Europe/Amsterdam"
    end
  end

  # Provision controller for Ansible on Windows host.
  if Vagrant::Util::Platform.windows? then
    config.vm.define "cd2-controller" do |controller|
      controller.vm.provider "virtualbox" do |vbox|
        vbox.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
      end
      controller.vm.box = BOX
      controller.vm.hostname = "cd2-controller"
      controller.vm.network :private_network, ip: NETWORK + "35", netmask: NETMASK
      controller.vm.synced_folder ".", "/vagrant", disabled: true
      controller.vm.provision "shell", privileged: false, path: "vagrant/provision_controller.sh"
      controller.vm.provision "shell",
        inline: "sudo timedatectl set-timezone Europe/Amsterdam"
    end
  end
end
