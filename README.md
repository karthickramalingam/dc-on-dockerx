# DC on Docker with [OpenSwitch](http://www.openswitch.net)

[![Build Status](https://travis-ci.org/keinohguchi/dc-on-docker.svg)](https://travis-ci.org/keinohguchi/dc-on-docker)
[![Buildtime trend](https://buildtimetrend.herokuapp.com/badge/keinohguchi/dc-on-docker/latest)](https://buildtimetrend.herokuapp.com/dashboard/keinohguchi/dc-on-docker/)
[![Stories in Ready](https://badge.waffle.io/keinohguchi/dc-on-docker.png?label=ready&title=ready)](https://waffle.io/keinohguchi/dc-on-docker)

Creating your own data-center (DC) on your laptop with Ansible and
Docker-Compose in a snap!

Here is [dc-on-docker in action](https://asciinema.org/a/44142),
which is the step-by-step screen cast how to create
[dc-on-docker](https://github.com/keinohguchi/dc-on-docker)
on your laptop with [vagrant](http://vagrantup.com),
[docker](http://docker.com), and [OpenSwitch](http://openswitch.net).

## Requirements

Ansible 2.1 and above, because OpenSwitch ansible roles, e.g. [ops switch role](http://github.com/keinohguchi/ops-switch-role), depends on Ansible 2.1 modules.

## Topology

```
                           
                           |1
                        +--+---+
                        | fab1 |
                        ++---+-+
                         |2  |3
                    +----+   +----+
                    |1            |1
                +---+----+   +----+---+
                | spine1 |   | spine2 |
                ++--+--+-+   +-+--+--++
                 |2 |3 |4      |2 |3 |4 
          +------+  |  |       |  |  +------+
          |         |  +-------|--|-----+   |
          |   +-----|----------+  |     |   |
          |   |     |             |     |   |
          |   |     +----+   +----+     |   |
          |1  |2         |1  |2         |1  |2
        +-+---+-+      +-+---+-+      +-+---+-+
        | leaf1 |      | leaf2 |      | leaf3 |
        +---+---+      +---+---+      +---+---+
            |3             |3             |3

```

## Setup

### Using Vagrant

* If you're under a proxy:

Make sure you have `http_proxy` and `https_proxy` available as environment variables if you are under a web proxy;

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

1. Download and install Virtualbox 5.0.16 from [virtualbox.org](https://www.virtualbox.org/wiki/Downloads);
2. Download and install Vagrant 1.8.1 from [vagrantup.com](https://releases.hashicorp.com/vagrant/1.8.1);
3. Install the required Vagrant plugins:

```
$ vagrant plugin install vagrant-proxyconf vagrant-vbguest
```

5. Create the virtual machine:

```
$ vagrant up
```

6. Accessing the virtual machine:

```
$ vagrant ssh
```

### Setup Topology

Single playbook to setup the above topology.  It's basically
It's primarily the `docker-compose` with the new `docker networking`
stuff, with additional tweaks for OpenSwitch interfaces:

```
  $ ansible-playbook utils/setup.yaml
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
  $ ansible-playbook --skip-tags bgp site.yaml
```

We need to skip the `bgp` related plays at this point as there is
an issue on [OpenSwitch bgp role](https://github.com/keinohguchi/ops-bgp-role).

### Specific play

You can only run the specific host by using the `--limit` option
as below:

```
  $ ansible-playbook --limit fabrics --skip-tags bgp site.yaml
```

for example, to run only the basic L2/L3 plays against the
[fabric switches](hosts).

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

Here is the [screenshot](https://gist.github.com/keinohguchi/fa22e11f65489ac6ad94707960a26c26)
of the `ansible-playbook site.yaml` for your reference.

Enjoy and happy hacking!
