# Cookbook Name:: sensu-server
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

package 'net-snmp' do
  action :install
end

template '/etc/snmp/snmpd.conf' do
  source 'snmpd.erb'
  owner  'root'
  group  'root'
  mode   '0755'
end

service 'snmpd' do
  action [ :start, :enable ]
end
