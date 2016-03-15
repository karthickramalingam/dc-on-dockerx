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
            |              |              | 
            |1             |1             |1
        +---+---+      +---+---+      +---+---+
        |  hs4  |      |  hs5  |      |  hs6  |
        +-------+      +-------+      +-------+

```

## Setup/teardown

There are two playbooks under `utils` directory to setup and teardown
the topology.  It's primarily the *docker-compose* with
*docker networking* stuff:

  $ ansible-playbook utils/setup.yaml

and teardown would be:

  $ ansible-playbook utils/teardown.yaml

## Play

There is only one play, to configure whole switch in one shot:

  $ ansible-playbook site.yaml

Enjoy and happy hacking!
