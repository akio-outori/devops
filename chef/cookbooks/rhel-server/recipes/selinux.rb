#
# Cookbook Name:: rhel-server
# Recipe:: basic_tools
#
# Copyright 2016, Jeff Hallyburton
#

# Selinux to permissive mode
#selinux_state "SELinux Permissive" do
#  action :permissive
#end

# Do this with shell until I can figure out a better way
execute 'selinux_permissive' do
  command 'setenforce 0'
end

