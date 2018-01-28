#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'hadoop::install_java'
include_recipe 'hadoop::create_hadoop_user'
include_recipe 'hadoop::install_hadoop'
# include_recipe 'hadoop::start_hadoop' 
