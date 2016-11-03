# l2mesh

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with l2mesh](#setup)
    * [What l2mesh affects](#what-l2mesh-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with l2mesh](#beginning-with-l2mesh)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module implements a layer 2 vpn using [tinc](http://www.tinc-vpn.org/ "tinc"), and exported resources.

## Module Description

It creates a new ethernet interface on the machine and connects it to
the switch.

Here is how the situation looks like when dealing with physical
machines and a hardware switch:


    +----------------+                        +---------------+
    |                |                        |               |
    |          +-----+                        +-----+         |
    | MACHINE  | eth0+---------+    +---------+eth0 | MACHINE |
    |    A     +-----+         |    |         +-----+   C     |
    |                |         |    |         |               |
    +----------------+     +---+----+---+     +---------------+
                           |  SWITCH    |
                           +-----+------+
                                 |
    +----------------+           |
    |                |           |
    |          +-----+           |
    | MACHINE  | eth0+-----------+
    |    B     +-----+
    |                |
    +----------------+
  
Each of the three machines ( *A, B, C* ) have a physical ethernet
connector which shows as *eth0*. They are connected with a cable to a
*SWITCH* which transmits the packet coming from *MACHINE A* to *MACHINE B*
or *MACHINE C*. 

With *l2mesh*, a new virtual interface ( named *L2M* below ) is
created on each machine and they are all connected by a [TINC daemon](http://www.tinc-vpn.org/). 
Packets go from *MACHINE A* to *MACHINE B* or *MACHINE C* as if they were
connected to a physical switch.

    +---------+-----+
    |         |eth0 |
    |         +-----+
    | MACHINE | L2M |
    |    A    +-----+
    |           TINC+---
    +--------------++   \-------
                   |            \-------   +---------------+
                   |                    X--+TINC           |
                   |            /-------   +-----+         |
     +-------------+-+   /------           | L2M | MACHINE |
     |           TINC+---                  +-----+    C    |
     |         +-----+                     |eth0 |         |
     | MACHINE | L2M |                     +-----+---------+
     |    B    +-----+
     |         |eth0 |
     +---------+-----+

Here is how it looks on each machine:

    $ ip link show eth0
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
       link/ether fa:16:3e:48:ae:6f brd ff:ff:ff:ff:ff:ff

    $ ip link show dev L2M
    2: L2M: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
       link/ether 72:75:6e:60:59:f0 brd ff:ff:ff:ff:ff:ff

## Setup

### What l2mesh affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with l2mesh

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

*l2mesh* is a puppet module that should be installed in the puppet master as follows

    git clone http://redmine.the.re/git/l2mesh.git /etc/puppet/modules/l2mesh

Here is an example usage that can be included in */etc/puppet/manifests/site.pp*

    node /MACHINE-A.example.com/, /MACHINE-B.example.com/ {
      include l2mesh::params
      
      l2mesh { 'L2M':
        ip                  => $::ipaddress_eth0,
        port                => 656,
      }
    }

On both *MACHINE-A* and *MACHINE-B*, it will 

* create the *L2M* ethernet interface 
* run the *tincd* daemon to listen on port *656* and
  bind it to the *$::ipaddress_eth0* IP address

In addition, both machines will try to reach each other:

* *tincd* on *MACHINE-A* will try to connect to *tincd* on *MACHINE-B*
* *tincd* on *MACHINE-B* will try to connect to *tincd* on *MACHINE-A*

Adding a new machine to the *L2M* virtual switch is done by adding the
hostname of the machine to the node list. For instance,
*MACHINE-C.example.com* can be added with:

    node /MACHINE-A.example.com/, /MACHINE-B.example.com/, /MACHINE-C.example.com/  {
    ...

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

## License

Copyright (C) 2012 eNovance <licensing@enovance.com>
Portions Copyright (C) 2016 Dylan Cochran <heliocentric@gmail.com>

Author: Loic Dachary <loic@dachary.org>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.


