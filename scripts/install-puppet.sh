#!/bin/bash

echo "Installing Puppet and supporting tools";

rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm

yum check-update -y

yum install puppet-agent -y 

/opt/puppetlabs/puppet/bin/gem install bundler
/opt/puppetlabs/puppet/bin/gem install r10k

ln -sf /opt/puppetlabs/bin/puppet /usr/bin/puppet
ln -sf /opt/puppetlabs/bin/facter /usr/bin/facter
ln -sf /opt/puppetlabs/puppet/bin/r10k /usr/bin/r10k
ln -sf /opt/puppetlabs/puppet/bin/gem /usr/bin/gem
ln -sf /opt/puppetlabs/puppet/bin/bundle /usr/bin/bundle

exit 0;
