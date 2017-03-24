# -*- mode: ruby -*-
# # vi: set ft=ruby :

# provision nomad
$script = <<SCRIPT
# Update apt and get dependencies
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y unzip curl wget vim

# Download Nomad
echo Fetching Nomad...
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/0.5.4/nomad_0.5.4_linux_amd64.zip -o nomad.zip

echo Installing Nomad...
unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

# Set hostname's IP to made advertisement Just Work
sudo sed -i -e "s/.*nomad.*/$(ip route get 1 | awk '{print $NF;exit}') nomad/" /etc/hosts

# Move config .hcl files to home folder
# mv ~/vagrant/*.hcl ~

SCRIPT
 
# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"
 
# Require YAML module
require 'yaml'
 
# Read YAML file with box details
servers = YAML.load_file('cluster.yaml')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 
  # Iterate through entries in YAML file
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
    config.vm.hostname = servers["hostname"]
    config.vm.provision "shell", inline: $script, privileged: false
    if servers["name"] == "nomad-client-one" || servers["name"] == "nomad-client-two"
      config.vm.provision "docker" # Just install it
    end
      srv.vm.box = servers["box"]
      srv.vm.network "private_network", ip: servers["ip"]
      srv.vm.provider :virtualbox do |vb|
        vb.name = servers["name"]
        vb.memory = servers["ram"]
      end
    end
  end
end