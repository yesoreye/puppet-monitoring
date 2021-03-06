# region Class: monitoring::grafana_stack::nginx::allinone
class monitoring::grafana_stack::nginx::allinone {
  notice('Nginx All in one class')
  selinux::port {
    'allow-graphite-8888' :
      ensure   => 'present',
      seltype  => 'http_port_t',
      protocol => 'tcp',
      port     => 8888,
  }
  ensure_resource('file', [ '/etc/nginx/conf.d' ],{
    ensure => directory,
  })
  ::nginx::resource::server { 'graphitewebserver' :
    ensure               => present,
    server_name          => ['_'],
    listen_port          => 8888,
    client_max_body_size => '64M',
    use_default_location => false,
    locations            => {
      '^~ /static/'  =>  {
        location_cfg_append => {
          root       => '/usr/share/pyshared/django/contrib/admin',
          access_log => 'off',
        }
      },
      '^~ /content/' =>  {
        location_cfg_append => {
          root       => '/opt/graphite/webapp/',
          access_log => 'off',
        },
        expires             => '30d',
      },
      '/'            => {
        proxy_set_header    => ['Host $http_host','X-Real-IP $remote_addr'],
        location_cfg_append => {
          proxy_pass_header     => 'Server',
          proxy_redirect        =>'off',
          proxy_connect_timeout => 10,
          proxy_read_timeout    => 60,
          proxy_pass            => 'http://unix:/var/run/graphite.sock',
        }
      }
    },
    require              => [
      Selinux::Port['allow-graphite-8888']
    ],
  }
}
#endregion

# region Class: monitoring::grafana_stack::nginx::base
class monitoring::grafana_stack::nginx::base {
  notice('Nginx Base class')
  include ::nginx
}
#endregion

# region Class: monitoring::grafana_stack::graphite::allinone
class monitoring::grafana_stack::graphite::allinone (){
  notice('Graphite All In One class')
  include ::graphite
}
#endregion

# region Class: monitoring::grafana_stack::graphite::base
class monitoring::grafana_stack::graphite::base (
  Array[String] $packages_graphite             = lookup('profiles::grafana_stack::packages::graphite'),
){
  notice('Graphite base class')
  ensure_packages($packages_graphite)
}
#endregion

# region Class: monitoring::grafana_stack::grafana::base
class monitoring::grafana_stack::grafana::base {
  notice('Grafana base class')
}
#endregion

# region Class: monitoring::grafana_stack::base
class monitoring::grafana_stack::base (
  Array[String] $packages_grafana_stack              = lookup('profiles::grafana_stack::packages::grafana_stack'),
  String        $username_system                     = lookup('profiles::grafana_stack::username::system'),
  String        $path_data                           = lookup('profiles::grafana_stack::path::data'),
  String        $path_logs                           = lookup('profiles::grafana_stack::path::logs'),
  String        $path_puppet                         = lookup('profiles::grafana_stack::path::puppet_scripts'),
  String        $path_dev_and_temp                   = lookup('profiles::grafana_stack::path::dev_and_temp_packages'),
  String        $path_installers                     = lookup('profiles::grafana_stack::path::installers'),
){
  notice('Grafana Stack base class')
  ensure_packages($packages_grafana_stack)
  ensure_resource('user', [ $username_system ], {
    ensure => 'present',
    name   => $username_system,
    system => true,
  })
  ensure_resource('file', [ $path_data, $path_logs, $path_puppet, $path_dev_and_temp, $path_installers ],{
    ensure => directory,
    owner  => $username_system,
    group  => $username_system,
  })
}
#endregion

# region Class: monitoring::base
class monitoring::base (
  Array[String] $packages_base              = lookup('profiles::grafana_stack::packages::base'),
){

  notice('Base class')
  ensure_packages($packages_base)

}
#endregion

# region Node: Node settings
node default {

  notice(lookup('welcome'))

  include ::monitoring::base
  include ::monitoring::grafana_stack::base
  include ::monitoring::grafana_stack::graphite::base
  include ::monitoring::grafana_stack::grafana::base
  include ::monitoring::grafana_stack::graphite::allinone
  include ::monitoring::grafana_stack::nginx::base
  include ::monitoring::grafana_stack::nginx::allinone

  Class['monitoring::base']                               -> Class['monitoring::grafana_stack::base']
  Class['monitoring::grafana_stack::base']                -> Class['monitoring::grafana_stack::graphite::base']
  Class['monitoring::grafana_stack::base']                -> Class['monitoring::grafana_stack::grafana::base']
  Class['monitoring::grafana_stack::graphite::base']      -> Class['monitoring::grafana_stack::graphite::allinone']
  Class['monitoring::grafana_stack::graphite::allinone']  -> Class['monitoring::grafana_stack::nginx::base']
  Class['monitoring::grafana_stack::nginx::base']         -> Class['monitoring::grafana_stack::nginx::allinone']

}
#endregion
