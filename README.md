# DC on Docker with [OpenSwitch](http://www.openswitch.net)

[![Build Status](https://travis-ci.org/keinohguchi/dc-on-docker.svg)](https://travis-ci.org/keinohguchi/dc-on-docker)
[![Latest build duration](https://buildtimetrend-dev.herokuapp.com/badge/buildtimetrend/service/latest)](https://buildtimetrend-dev.herokuapp.com/dashboard/buildtimetrend/service/index.html)
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

## Tear down

Teardown the topology, after the party.

```
  $ ansible-playbook utils/teardown.yaml
```

## Screenshot

Here is the [screenshot](https://gist.github.com/keinohguchi/fa22e11f65489ac6ad94707960a26c26)
of the `ansible-playbook site.yaml` for your reference.

Enjoy and happy hacking!
