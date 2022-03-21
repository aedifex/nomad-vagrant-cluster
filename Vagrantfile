# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
echo "Installing Docker..."
sudo apt-get update
sudo apt-get remove docker docker-engine docker.io
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
sudo apt-get update
sudo apt-get install -y docker-ce
# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
sudo service docker restart
# Make sure we can actually use docker as the vagrant user
sudo usermod -aG docker vagrant
sudo docker --version

# Packages required for nomad & consul
sudo apt-get install unzip curl vim -y

echo "Installing Nomad..."
NOMAD_VERSION=1.0.1
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
unzip nomad.zip
sudo install nomad /usr/bin/nomad
sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

for bin in cfssl cfssl-certinfo cfssljson
do
  echo "Installing $bin..."
  curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
  sudo install /tmp/${bin} /usr/local/bin/${bin}
done
nomad -autocomplete-install


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
	config.vm.box = "hashicorp/bionic64"
	
	# Iterate through YAML
	# config file; server metadata
	# is contained there.
	servers.each do |servers|
		# For each entry, configure a VM.
		# Each "name" is a logical Vagrant identifier.
		config.vm.define servers["name"] do |server|
		
			server.vm.hostname = servers["hostname"]
			
			# TODO - learn more about the different
			# Vagrant network configuration options, i.e. private.
			server.vm.network "private_network", ip: servers["ip"]

			# Enable access to Nomad UI via host machine.
			server.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true, host_ip: "127.0.0.1"

			# Enable access to Docker hello world app.
			server.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true, host_ip: "127.0.0.1"
			
			# Provision VM with inline script defined above.
			server.vm.provision "shell", inline: $script

			# This _should_ happen automatically. We're explicitly syncing
			# the a folder between the host and guest environments.
			# Useful because it makes sharing the Makefile and config stuff
			# seamless. updated the local sync folder
			server.vm.synced_folder "../nomad-vagrant-cluster", "/home/vagrant/nomad"
			
			# Hacky. We're using using an envar to represent
			# the "public" ip we're assigning to each VM.
			# One of our config scripts will use this when it comes time
			# run the Nomad binaries.
			server.vm.provision "shell" do |s|
				s.inline = "echo export IP_ADDR=$1 > /home/vagrant/.profile"
				s.args   = "#{servers["ip"]}"
			end
			
			server.vm.provider :virtualbox do |vb|
				vb.name = servers["name"]
				vb.memory = servers["ram"]
			end
		end
	end
end
