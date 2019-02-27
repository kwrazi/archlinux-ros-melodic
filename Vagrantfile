# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://www.vagrantup.com/docs/vagrantfile/vagrant_version.html
Vagrant.require_version ">= 2.0.1"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "terrywang/archlinux"

  config.vm.box_check_update = true
  # config.vbguest.auto_update = false
  # config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  config.vm.hostname = "ros-melodic"

  config.vm.provider :virtualbox do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.name = "ros-melodic"
    vb.gui = true
    # Customize the amount of memory on the VM:
    vb.cpus = 4
    vb.memory = "12288"
  end

  config.vm.define :melodic do |melodic|
    melodic.vm.network "private_network", ip: "192.168.101.47"
    melodic.vm.hostname = "ros-melodic"
  end

  config.vm.provision :shell, inline: <<-SHELL
    echo "update system..."
    pacman -Syu --noconfirm
    echo "install essential applications..."
    pacman -Sy --noconfirm --needed base-devel git tree tmux htop vim mlocate pkgfile mtr
    pacman -Sy --noconfirm --needed virtualbox-guest-utils
    pacman -Sy --noconfirm virtualbox-guest-dkms
  SHELL

  #config.vm.provision :shell, privileged: false, path: "provision.sh"  ## :args => "/vagrant ros-melodic-desktop-full"
  #config.vm.provision :shell, privileged: false, path: "provision.sh", :args => "/vagrant ros-melodic-desktop"
  config.vm.provision :shell, privileged: false, path: "provision.sh", :args => "/vagrant ros-melodic-ros-base"

end

