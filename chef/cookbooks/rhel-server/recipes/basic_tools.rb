#
# Cookbook Name:: rhel-server
# Recipe:: basic_tools
#
# Copyright 2016, Jeff Hallyburton
#

# This is a test to install some basic packages using chef.
package 'Basic Tools' do
  package_name ['wget', 'elinks', 'nano', 'screen', 'net-tools', 'git', 'telnet', 'gcc', 'glibc', 'glibc-common', 'sudo']
  action :install
end




