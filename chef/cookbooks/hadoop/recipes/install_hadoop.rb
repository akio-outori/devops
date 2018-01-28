#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/home/#{node.hadoop_user}/hadoop-#{node.version}.tar.gz" do
    source "http://apache.claz.org/hadoop/common/hadoop-2.6.4/hadoop-#{node.version}.tar.gz"
    owner  "#{node.hadoop_user}"
    group  "#{node.hadoop_user}"
    mode   0755
    action :create
end

execute 'extract_hadoop' do
    command "tar -xvf /home/#{node.hadoop_user}/hadoop-#{node.version}.tar.gz -C #{node.lib_path}"
    user    'root'
    group   'root'
    cwd     "/home/#{node.hadoop_user}"
    not_if  { File.exists?("#{node.hadoop_path}") }
end

execute 'set_executable' do
    command "find #{node.hadoop_path} -name *.sh | xargs -i chmod 750 {}"
    user    'root'
    group   'root'
end

execute "chown-hadoop" do
    command "chown -R #{node.hadoop_user}:#{node.hadoop_user} #{node.hadoop_path}"
    user    "root"
end

template "/home/#{node.hadoop_user}/.bashrc" do
    source "bashrc/hadoop"
    owner  "#{node.hadoop_user}"
    group  "#{node.hadoop_user}"
    mode   0644
    variables({
        :hadoop_path => "#{node.hadoop_path}",
        :version     => "#{node.version}"
    })
end

bash 'bashrc' do
    code "source /home/#{node.hadoop_user}/.bashrc"
end

for config in ['core-site.xml', 'hdfs-site.xml', 'mapred-site.xml', 'yarn-site.xml'] do
    template "#{node.hadoop_path}/etc/hadoop/#{config}" do
        source "hadoop/#{config}"
        owner  "#{node.hadoop_user}"
        group  "#{node.hadoop_user}"
        mode   0644
    end
end

template "home/#{node.hadoop_user}/hadoop_init.sh"  do
    source "scripts/hadoop_init.sh"
    owner  node.hadoop_user
    group  node.hadoop_user
    mode   0750
    variables({
        :hadoop_path => "#{node.hadoop_path}",
    })
end

