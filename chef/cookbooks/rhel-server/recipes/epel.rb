#
# Cookbook Name:: rhel-server
# Recipe:: epel
#
# Copyright 2016, Jeff Hallyburton
#

# Update ca-certificates (needed sometimes on RHEL6)
package 'ca-certificates' do
  action :upgrade
end 

# Install EPEL
package 'epel-release' do
  action :install
end




