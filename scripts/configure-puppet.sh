#!/bin/bash

echo "Configuring Puppet";

mkdir -p /etc/puppet/{modules,hieradata,.dev}/

/opt/puppetlabs/puppet/bin/r10k puppetfile install --puppetfile /etc/puppet/Puppetfile --moduledir /etc/puppet/modules

exit 0;
