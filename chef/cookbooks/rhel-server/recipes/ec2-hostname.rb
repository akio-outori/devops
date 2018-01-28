# Cookbook Name:: sensu-server
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

ruby_block "update_cloud.cfg" do
  block do
    file = Chef::Util::FileEdit.new("/etc/cloud/cloud.cfg")
    file.insert_line_if_no_match("preserve_hostname: true", "preserve_hostname: true")
    file.write_file
  end
end

ruby_block "update /etc/hostname" do
  block do
    if (defined?(node.default['hostname'])).nil?
      file = Chef::Util::FileEdit.new("/etc/hostname")
      file.search_file_replace_line("node['hostname']", "node.default['hostname']")
      file.write_file
    end
  end
end
