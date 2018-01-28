#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user "#{node.hadoop_user}" do
    comment 'User for managing the Hadoop cluster'
    home "/home/#{node.hadoop_user}"
    shell '/bin/bash'
    action :create
end

execute "generate ssh skys for #{node.hadoop_user}." do
        user "#{node.hadoop_user}"
        creates "/home/#{node.hadoop_user}/.ssh/id_rsa.pub"
        command "ssh-keygen -t rsa -q -f /home/#{node.hadoop_user}/.ssh/id_rsa -P \"\""
end

file "/home/#{node.hadoop_user}/.ssh/id_rsa" do
    owner  'hadoop'
    group  'hadoop'
    mode   '0600'
    action :touch
end

remote_file "/home/#{node.hadoop_user}/.ssh/authorized_keys" do
    source  "file:///home/#{node.hadoop_user}/.ssh/id_rsa.pub"
    owner   'hadoop'
    group   'hadoop'
    mode    '0600'
    action  :create
end



