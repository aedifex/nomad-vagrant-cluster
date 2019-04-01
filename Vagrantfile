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
curl -sSL $Nomad_Version -o nomad.zip

echo Installing Nomad...
unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

# system
sudo cp /vagrant/nomad-server.service /etc/systemd/system/nomad-server.service

# Set hostname's IP to made advertisement Just Work
sudo sed -i -e "s/.*nomad.*/$(ip route get 1 | awk '{print $NF;exit}') nomad/" /etc/hosts

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
    # Moving forward, we should mount the specific
    # config files needed...nothing more.
    # config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.define servers["name"] do |srv|
    config.vm.hostname = servers["hostname"]
    config.vm.provision "shell", inline: $script, env: {"Nomad_Version" => "https://releases.hashicorp.com/nomad/0.8.7/nomad_0.8.7_linux_amd64.zip"}, privileged: false
    if servers["name"] == "nomad-client-one" || servers["name"] == "nomad-client-two"
      config.vm.provision "docker"
      config.vm.provision "shell",
        inline: "sudo cp /vagrant/nomad-client.service /etc/systemd/system/nomad-client.service && sudo systemctl enable nomad-client.service && sudo systemctl start nomad-client.service"
    end
    if servers["name"] == "nomad-server"
      config.vm.provision "shell",
        inline: "sudo cp /vagrant/nomad-server.service /etc/systemd/system/nomad-server.service && sudo systemctl enable nomad-server.service && sudo systemctl start nomad-server.service"
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