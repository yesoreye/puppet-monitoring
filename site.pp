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
){
  notice('Grafana Stack base class')
  ensure_packages($packages_grafana_stack)
  ensure_resource('user', [ $username_system ], {
    ensure => 'present',
    name   => $username_system,
    system => true,
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

}
#endregion
