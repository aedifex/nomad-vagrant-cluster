# Nomad-Vagrant Cluster

This cluster is used primarily to test Nomad.

## Prereqs

[Vagrant](https://www.vagrantup.com/)

[Virtualbox](https://www.virtualbox.org/)


## Getting started

Once you've cloned the repo, the ```Vagrantfile``` will bootstrap three virtual-machines; a Nomad Server and two Nomad Clients.

Run:

```vagrant up```

After creating the virtual machines, ```vagrant status``` will tell you if everything is working.

```
christopherblack$ vagrant status
Current machine states:

nomad-server              running (virtualbox)
nomad-client-one          running (virtualbox)
nomad-client-two          running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```


## Setting up the cluster

Connect to the Server first:


We can connect to a machine via SSH:

```vagrant ssh nomad-server```

Once connected copy the config file to the home directory:

`cp /vagrant/server.hcl .`

Then run:

`sudo nomad agent -config server.hcl`

The process is the same for the two Clients.

1. vagrant ssh nomad-client-one
2. `cp /vagrant/client.hcl .`
3. `sudo nomad agent -config client.hcl`

