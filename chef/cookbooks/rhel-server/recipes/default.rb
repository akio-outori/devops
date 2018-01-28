# Cookbook Name:: sensu-server
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

include_recipe 'basic_tools'
include_recipe 'selinux'
include_recipe 'epel'
include_recipe 'firewall'
include_recipe 'net-snmp'
include_recipe 'ntp'
include_recipe 'ec2-hostname'
