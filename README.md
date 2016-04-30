# DC on Docker with [OpenSwitch](http://www.openswitch.net)

[![Build Status](https://travis-ci.org/keinohguchi/dc-on-docker.svg)](https://travis-ci.org/keinohguchi/dc-on-docker)

Creating your own data-center (DC) on your laptop with Ansible and
Docker-Compose in a snap!

Here is the [screen cast](https://asciinema.org/a/44142) to show you
how to create your own DC in your vagrant environment.

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

## Play

Now, you're ready for play, and of course, it's called `site.yaml`:

```
  $ ansible-playbook site.yaml
```

## Tear down

Teardown the topology, once you have a fun:

```
  $ ansible-playbook utils/teardown.yaml
```

## Screenshot

Here is the [screenshot](https://gist.github.com/keinohguchi/fa22e11f65489ac6ad94707960a26c26)
of the `ansible-playbook site.yaml` for your reference.

Enjoy and happy hacking!
