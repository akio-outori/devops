#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'Install Java' do
    package_name ['java-1.7.0-openjdk']
    action :install
end


