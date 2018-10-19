# region Class: monitoring::grafana_stack::graphite::base
class monitoring::grafana_stack::graphite::base {
  notice('Graphite base class')
}
#endregion

# region Class: monitoring::grafana_stack::grafana::base
class monitoring::grafana_stack::grafana::base {
  notice('Grafana base class')
}
#endregion

# region Class: monitoring::grafana_stack::base
class monitoring::grafana_stack::base {
  notice('Grafana Stack base class')
}
#endregion

# region Class: monitoring::base
class monitoring::base {

  notice('Base class')

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
