# Class: monitoring::base
#
#
class monitoring::base {

  notice('Base class')

}

node default {

  notice(lookup('welcome'))

  include ::monitoring::base

}
