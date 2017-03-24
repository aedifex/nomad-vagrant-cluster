# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/client1"

# Enable the client
client {
    enabled = true

    # For demo assume we are talking to server1. For production,
    # this should be like "nomad.service.consul:4647" and a system
    # like Consul used for service discovery.
    servers = ["172.17.8.101:4647"]
}

# Advertise an accessible IP address so the server is reachable by other servers
# and clients. The IPs can be materialized by Terraform or be replaced by an
# init script.
advertise {
    http = "172.17.8.102:4646"
    rpc = "172.17.8.102:4647"
    serf = "172.17.8.102:4648"
}
