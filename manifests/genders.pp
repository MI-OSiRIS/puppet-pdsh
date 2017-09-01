# basic config for genders
# included by class pdsh as needed
class pdsh::genders {

    package { 'pdsh-mod-genders': ensure  => present }

   # Verify /etc/genders file exists
   file { '/etc/genders':
      ensure   => 'file',
      mode     => '0644',
      owner    => "root",
      group    => "root",
      tag      => 'pdsh'
   }
}
