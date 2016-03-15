# DC on Docker

Creating your own data-center (DC) on your laptop
with Ansible and Docker-Compose in a snap!

## Requirements

Ansible 2.1 and above, just like [OpenSwitch switch role](http://github.com/keinohguchi/ops-switch-role).

## Topology

```
                           
                           |1
                       +---+---+
                       |  sw1  |
                       +-+---+-+
                         |2  |3
                    +----+   +----+
                    |1            |1
                +---+---+     +---+---+
                |  sw2  |     |  sw3  |
                ++--+--++     ++--+--++
                 |2 |3 |4      |2 |3 |4 
          +------+  |  |       |  |  +------+
          |         |  +-------|--|-----+   |
          |   +-----|----------+  |     |   |
          |   |     |             |     |   |
          |   |     +----+   +----+     |   |
          |1  |2         |1  |2         |1  |2
        +-+---+-+      +-+---+-+      +-+---+-+
        |  sw4  |      |  sw5  |      |  sw6  |
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

Enjoy and happy hacking!
