#!/bin/bash

echo "Executing puppet";
puppet apply --hiera_config=/etc/puppet/hiera.yaml --modulepath=/etc/puppet/modules/ /etc/puppet/site.pp

exit 0;
