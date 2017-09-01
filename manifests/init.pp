# base pdsh class
# include on nodes where you want pdsh and enabled pdsh modules to be installed
#
# Dependencies:
#   marcgascon-profile_d
#
# Supported OS:
#   RHEL variants.  Tested on RHEL6 and RHEL7
#
# Params:
#
#  default_group_module (string)
#    Options are 'dshgroup' or 'genders'.  Defines PDSH_MISC_MODULES with selected module in profile.d/pdsh.sh
#
#  enable_dshgroup (boolean)
#     Install packages and ensure presence of basic files/directories needed for pdsh::node resources to use dsh group definitions
#
#  enable_genders (boolean)
#     Install packages and ensure presence of /etc/genders for resources to use gender group definitions
#
#   NOTE:  Both genders and groups can be enabled if desired.  Collected pdsh::node resources default to referencing
#          the value from this class but can also take a param to over-ride.
#          Users can over-ride the PDSH_MISC_MODULES environment variable to use the one of their choice.


class pdsh (
   $default_group_module = 'dshgroup',
   $enable_dshgroup = true,
   $enable_genders  = true,
) {

   package { 'pdsh': ensure => present }

   if ( $enable_dshgroup == true ) {
      include pdsh::dshgroup
   }

   if ( $enable_genders == true ) {
      include pdsh::genders
   }

   file { '/etc/machines.list':
      ensure   => 'file',
      mode     => '0644',
      owner    => "root",
      group    => "root",
      tag      => 'pdsh'
   }

   profile_d::script { 'pdsh.sh':
      content  => template('pdsh/pdsh.sh.erb')
   }

   # if puppet is run with this fact set it will recreate from scratch all the group files
   # FACTER_pdsh_cleanup='true' puppet agent -t
   if $::pdsh_cleanup {
      Exec['pdsh_cleanup'] -> File <| tag == 'pdsh' |>
         exec { 'pdsh_cleanup':
            command => '/bin/rm -f /etc/dsh/group/* ; /bin/rm -f /etc/machines.list; /bin/rm -f /etc/genders'
         }
      }
}
