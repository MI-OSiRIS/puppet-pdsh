<h1>puppet-pdsh</h1>

<p>Puppet module to configure pdsh and node group definitions using exported resources</p>

<b>base pdsh class
include on nodes where you want pdsh and enabled pdsh modules to be installed<b>

Dependencies:
  marcgascon-profile_d

Supported OS:
  RHEL variants.  Tested on RHEL6 and RHEL7

Params:

 `default_group_module (string)`
   Options are 'dshgroup' or 'genders'.  Defines PDSH_MISC_MODULES with selected module in profile.d/pdsh.sh

 `enable_dshgroup (boolean)`
    Install packages and ensure presence of basic files/directories needed for pdsh::node resources to use dsh group definitions

 `enable_genders (boolean)`
    Install packages and ensure presence of /etc/genders for resources to use gender group definitions

  <i>NOTE:  Both genders and/or groups are optional and can be enabled if desired.  Collected pdsh::node resources default to 
         referencing the value from this class but can also take a param to over-ride.
         Users can over-ride the PDSH_MISC_MODULES environment variable to use the one of their choice.</i>
