# basic config for dshgroups
# included by pdsh class as needed

class pdsh::dshgroup {

   # pdsh-mod-dshgroup for /etc/groups/filename where filename is the name of the group and file contains list of group members
   package { 'pdsh-mod-dshgroup': ensure => present }

   # Verify /etc/dsh directory exists
   file { '/etc/dsh':         ensure => 'directory', }

   # Verify /etc/dsh/group directory exists
   file { '/etc/dsh/group':   ensure => 'directory', }

   # Verify /etc/dsh/machines.list is a symlink
   file { '/etc/dsh/machines.list': ensure => 'link', target => '/etc/machines.list', }
}
