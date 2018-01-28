#
# Cookbook Name:: sensu-server
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

# This is a test to install some basic packages using chef.
package 'Basic Tools' do
  package_name ['wget', 'elinks', 'nano', 'screen', 'net-tools', 'git', 'telnet', 'gcc', 'glibc', 'glibc-common', 'sudo']
  action :install
end

# Update the hosts file with the local ipv4 address pointed to chef-server.local
ruby_block "update_hosts_file" do
  block do
    file = Chef::Util::FileEdit.new("/etc/hosts")
    file.insert_line_if_no_match("node['ipaddress'] chef-server.local chef-server", "node['ipaddress'] chef-server.local chef-server")
    file.write_file
  end
end



