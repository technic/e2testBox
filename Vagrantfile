# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Based on Ubuntu 16.04
  config.vm.box = "ubuntu/xenial32"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    # Customize VirtualBox machine
    vb.memory = "1024"
    vb.customize ["modifyvm", :id, "--vram", "64", "--accelerate3d", "on", "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.provision "setup", type: "shell", path: "provision/setup.sh"
  config.vm.provision "cfg-fetch", type: "file", source: "provision/dotfiles", destination: "$HOME/"
  config.vm.provision "cfg-install", type: "shell", privileged: false,
    inline: "rsync -r -u -i -h /vagrant/provision/dotfiles/ $HOME && rm -r $HOME/dotfiles"
  config.vm.provision "build", type: "shell", privileged: false, path: "provision/build.sh"

end
