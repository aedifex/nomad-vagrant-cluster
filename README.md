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

Currently we have to manually bootstrap the client & server agents. The next iteration of this project will use a service like `upstart` to automatically bootstrap the services...for now, simple `vagrant ssh` into the nomad-server, and *both* clients, and run:

`nomad agent -config /vagrant/server.hcl` on the server.
`nomad agent -config /vagrant/client.hcl` on the clients.

`nomad status` will indicate if they're running.

Once we've bootstrapped the cluster, we're ready to start running jobs!


## Running your first job


```vagrant ssh nomad-server``` will connect you to the Nomad Server running locally.

```$ nomad job init``` will create a sample job.

`nomad job run example.nomad` will run the job.

We should see output that looks something like

```
==> Monitoring evaluation "dbf3b537"
    Evaluation triggered by job "example"
    Allocation "2ebc1e19" created: node "fe34f75c", group "cache"
    Evaluation within deployment: "706c024d"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "dbf3b537" finished with status "complete"
```

`nomad status` should return

```
ID       Type     Priority  Status   Submit Date
example  service  50        running  2019-03-18T16:06:49Z
```

The ID is the canonical ID of the job itself.

If/when we wanted to stop the job; `nomad stop example` would do the trick. However, we want the job to keep running to exercise a few commands.

Running `nomad status` followed by the job ID will return even more information about the job...including the allocation ID.

`nomad status example`

An allocation represents a relationship between a "job" and an "executor", that is to say a unit of work. Each allocation is unique. An allocation is the resultant of an evaluation, which takes place every time there is a change in state...i.e. a job is ran. An allocation represents a single execution context between the server(s) and a client with available system resource to process the job.

To get even more granular, `nomad alloc status 885958a4` with the alloc ID as a parameter will return the job id, eval id, status, and other important pieces of information. Nomad node id represents the client in which the job was processed. This can be very helpful if say a job keeps failing because it is being dispatched to an unhealthy client.

With alloc status, we can see the system resources that were `alloc`ated to the corresponding job.

This is by no means an exhaustive overview of Nomad. I hope that this helps provide a high-level overview.

## Additional Resources

https://github.com/hashicorp/nomad-guides
https://github.com/oribaldi/nomad-cluster
https://github.com/jamesdmorgan/nomad-cluster
