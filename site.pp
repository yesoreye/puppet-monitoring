# region Class: monitoring::grafana_stack::graphite::base
class monitoring::grafana_stack::graphite::base {
  notice('Graphite base class')
  ensure_packages(['MySQL-python','pyOpenSSL','python-ldap','python-memcached','python-psycopg2','python-zope-interface','python-tzlocal','python-sqlite3dbm', 'dejavu-fonts-common', 'dejavu-sans-fonts', 'python-cairocffi','python2-crypto'])
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

  ensure_packages(['wget','nano','git','nc','jq'])

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
