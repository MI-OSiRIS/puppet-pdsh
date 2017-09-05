<h1>puppet-pdsh</h1>

<p>Puppet module to configure pdsh and node group definitions using exported resources</p>

Dependencies:
  marcgascon-profile_d

Supported OS:
  RHEL variants.  Tested on RHEL6 and RHEL7
  
## Example Usage

Export the pdsh::node resource on every node you want to be setup as a target for pdsh.  Groups can be whatever you like, often people might use some common facts to group nodes or your own internal facts defined on every node.  
```
@@pdsh::node { "$::fqdn":
   pdsh_grouplist => [  $::somefact, $some_group, 'samplegroup' ]
}
```
Setup pdsh and collect the resources on a node you want to use to run pdsh commands (could be all nodes as well):
```  
Class { 'pdsh': }
  
Pdsh::Node <<| |>>
``` 
 After puppet has run and exported the resource on all of your hosts the groups will be setup when we gather the resources.  Then you should be able to do:
``` 
user@host: pdsh -g samplegroup 'uname -a'
``` 
## Class: pdsh

Include on nodes where you want pdsh and enabled pdsh modules to be installed

### Params:

##### `default_group_module (string)`

Options are 'dshgroup' or 'genders'.  Defines PDSH_MISC_MODULES with selected module in profile.d/pdsh.sh

##### `enable_dshgroup (boolean)`

Install packages and ensure presence of basic files/directories needed for pdsh::node resources to use dsh group definitions

##### `enable_genders (boolean)`

Install packages and ensure presence of /etc/genders for resources to use gender group definitions

  <i>NOTE:  Both genders and/or groups are optional and can be enabled if desired.  Collected pdsh::node resources default to 
         referencing the value from this class but can also take a param to over-ride.
         Users can over-ride the PDSH_MISC_MODULES environment variable to use the one of their choice.</i>
         
## Resource: pdsh::node

Defines a pdsh node and places in gender or dsh style groups
The name used for the node is the same as the resource title

Generally this will be used as an exported resource. To be later collected and have the group configuration realized on designated systems.  See example in this readme.  

### Params:

##### `enable_dshgroup (boolean)`

Add node to /etc/dsh/group/$groupname for each group in list.
Defaults to value of pdsh::enable_dshgroup

#####  `enable_genders (boolean)`

Add node to /etc/genders with groups as in list
Defaults to value of pdsh::enable_genders

##### `pdsh_grouplist (array)`

Which groups the node is in.  Defines appropriate config in files for gender or dshgroup as enabled.  

##### `ensure`

If ensure => absent the node will be removed from files
