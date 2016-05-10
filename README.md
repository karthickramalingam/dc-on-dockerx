# DC on Docker with [OpenSwitch](http://www.openswitch.net)

[![Build Status](https://travis-ci.org/keinohguchi/dc-on-docker.svg)](https://travis-ci.org/keinohguchi/dc-on-docker)
[![Buildtime trend](https://buildtimetrend.herokuapp.com/badge/keinohguchi/dc-on-docker/latest)](https://buildtimetrend.herokuapp.com/dashboard/keinohguchi/dc-on-docker/)
[![Stories in Ready](https://badge.waffle.io/keinohguchi/dc-on-docker.png?label=ready&title=ready)](https://waffle.io/keinohguchi/dc-on-docker)

Creating your own data-center (DC) on your laptop with Ansible and
Docker-Compose in a snap!

## Requirements

Ansible 2.1 and above, because OpenSwitch ansible roles, e.g. [ops switch role](http://github.com/keinohguchi/ops-switch-role), depends on Ansible 2.1 modules.

### Using Vagrant

You can use [vagrant](http://vagrantup.com) to create a sandboxed Ansible
control machine, if you want to test it out, though this is actually not
a requirement.  But if you do, here is some tips to set the vagrant
environment up.

#### Proxy setup

If you're behind a proxy, make sure you have `http_proxy` and `https_proxy`
available as environment variables if you are under a web proxy;

* On Windows

```
set http_proxy=%WEB_PROXY_URL%
set https_proxy=%WEB_PROXY_URL%
```

* On Linux or OSX

```
export http_proxy=$WEB_PROXY_URL
export https_proxy=$WEB_PROXY_URL
```

#### Virtualbox

Download and install Virtualbox 5.0.16 from [virtualbox.org](https://www.virtualbox.org/wiki/Downloads);

#### Vagrant

Download and install Vagrant 1.8.1 from [vagrantup.com](https://releases.hashicorp.com/vagrant/1.8.1);

Optionary, you can install required vagrant plugins:

```
$ vagrant plugin install vagrant-proxyconf vagrant-vbguest
```

#### Useful commands

Create the virtual machine:

```
$ vagrant up
```

Accessing the virtual machine:

```
$ vagrant ssh
```

## Topology

```

                          |1
                       +--+---+
                       | fab1 |
                       +-+--+-+
                         |2 |3
                    +----+  +----+
                    |1           |1
                +---+----+  +----+---+
                | spine1 |  | spine2 |
                +-+---+--+  +--+---+-+
                  |2  |3       |2  |3
           +------+  ++        ++  +------+
           |1        |1         |1        |1
       +---+---+ +---+---+  +---+---+ +---+---+
       | leaf1 | | leaf2 |  | leaf3 | | leaf4 |
       +-+---+-+ +-+---+-+  +-+---+-+ +-+---+-+
         |2  |3    |2  |3     |2  |3    |2  |3

```

## Setup

### Topology setup

Single playbook to setup the above topology.  It's basically
It's primarily the `docker-compose` with the new `docker networking`
stuff, with additional tweaks for OpenSwitch interfaces:

```
  $ ansible-playbook utils/setup.yaml
```

#### Single docker topology

You can also create a smaller topology, say single docker topology,
primaliry for the testing purpose, as demonstrated on the
[asciinema](https://asciinema.org/a/44984).  Here is the example
how to create a single docker instance topology:

```
  $ ansible-playbook --limit fabrics:docker --extra-vars "docker_compose_file=docker-compose1.yaml docker_network_script=docker-network1.sh" utils/setup.yaml
```

After this, you can run the test file, say `tests/test_switch.yml`, as below:

```
  $ ansible-playbook tests/test_switch.yml
```

### Switch health

You can check the switch reachability by running the `utils/ping.yaml`
playbook, as below:

```
  $ ansible-playbook utils/ping.yaml
```

## Play

Now, you're ready for play, and of course, it's called `site.yaml`:

```
  $ ansible-playbook site.yaml
```

### Specific play

You can only run the specific host by using the `--limit` option
as below:

```
  $ ansible-playbook --limit fabrics site.yaml
```

for example, to run only against the [fabric switches](hosts).

### Test

You can run the test locally as simple as one liner.  We embrace the
TDD philosophy here, too.

```
  $ ansible-playbook tests/test_bridge.yml
```

Here is the [asciicast](https://asciinema.org/a/44717), as test in action.

## Tear down

Teardown the topology, after the party.

```
  $ ansible-playbook utils/teardown.yaml
```

## Screenshot

Here is dc-on-docker in action [screencast](https://asciinema.org/a/44142) on [asciicast](https://asciinema.org), that shows you how to create VirtualBox based
Ansible control machine from scratch and actual
[dc-on-docker](https://github.com/keinohguchi/dc-on-docker) in action.

Enjoy and happy hacking!
