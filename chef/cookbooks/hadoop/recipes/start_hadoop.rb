#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash 'hadoop-env.sh' do
    code  "#{node.hadoop_root}/etc/hadoop/hadoop-env.sh"
    user  node.hadoop_user
    group node.hadoop_user
end

bash 'format hdfs' do
    code  "#{node.hadoop_root}/bin/hdfs namenode -format"
    user  node.hadoop_user
    group node.hadoop_user
    environment ({
        'JAVA_HOME'                    => '/usr/lib/jvm/jre',
        'HADOOP_HOME'                  => "#{node.hadoop_root}",
        'HADOOP_INSTALL'               => "#{node.hadoop_root}",
        'HADOOP_MAPRED_HOME'           => "#{node.hadoop_root}",
        'HADOOP_COMMON_HOME'           => "#{node.hadoop_root}",
        'HADOOP_HDFS_HOME'             => "#{node.hadoop_root}",
        'HADOOP_YARN_HOME'             => "#{node.hadoop_root}",
        'HADOOP_COMMON_LIB_NATIVE_DIR' => "#{node.hadoop_root}"
    })
end

for script in ['start-dfs.sh', 'start-yarn.sh'] do
    bash 'start_resources' do
        code  "#{script}"
        user  node.hadoop_user
        group node.hadoop_user
    end
end
