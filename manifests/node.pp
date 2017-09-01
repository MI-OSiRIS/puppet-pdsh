# pdsh_node
# defines a pdsh node and places in gender or dsh style groups
# The name used for the node is the same as the resource title
#
# Generally this will be used as an exported resource:  @@pdsh::node { "$::fqdn": }
# To be later collected and have the group configuration realized on designated systems:  Pdsh::Node <<| |>>

# Params:
#
#  enable_dshgroup (boolean)
#     Add node to /etc/dsh/group/$groupname for each group in list.
#     Defaults to value of pdsh::enable_dshgroup
#
#  enable_genders (boolean)
#     Add node to /etc/genders with groups as in list
#     Defaults to value of pdsh::enable_genders
#
#  pdsh_grouplist (array)
#     which groups the node is in
#
#  ensure
#      If ensure => absent the node will be removed from files

define pdsh::node (
   $enable_dshgroup = $pdsh::enable_dshgroup,
   $enable_genders  = $pdsh::enable_genders,
   $pdsh_grouplist  = [],
   $ensure          = 'present'
) {

   $pdsh_nodename  = "${name}"

   # remove empty strings
   $grouplist_real = delete($pdsh_grouplist, '')


    file_line { "$pdsh_nodename":
      ensure   => $ensure,
      path     => '/etc/machines.list',
      line     => "$pdsh_nodename #puppet entry",
      match    => "^$pdsh_nodename.*$",
   }

   if $enable_dshgroup {
       $grouplist_real.each | String $pdsh_group | {

         # this resource will end up being specified multiple times by each pdsh::node declaration in the same group
         # ensure_resource ensure the resource declarations don't conflict and only creates if doesn't exist already
         # there are some good reasons to generally avoid this function but this is an ideal case for it
         # there is also a defined() function that can be used to avoid double-definition of resources (and resulting compile failure)
         ensure_resource('file', "/etc/dsh/group/$pdsh_group",
            {
               'mode'    => '0644',
               'owner'   => 'root',
               'group'   => 'root',
               'ensure'  => 'file',
               'tag'     => 'pdsh'
            })

         file_line { "dsh-${pdsh_group}-${name}":
            ensure   => $ensure,
            path     => "/etc/dsh/group/$pdsh_group",
            line     => "$pdsh_nodename # puppet entry",
            match    => "^$pdsh_nodename.*$"
         }
      }
   }

   if $enable_genders {

      $gender_grouplist=join($grouplist_real,",")

      if ( size($gender_grouplist) > 0 ) {
         file_line { "genders-${name}":
            ensure   => $ensure,
            path     => '/etc/genders',
            line     => "$pdsh_nodename attr=${gender_grouplist} # puppet entry",
            match    => "$pdsh_nodename .*$",
            replace  => true,
         }
      }
   }

}

