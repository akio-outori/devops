# Cookbook Name:: sensu-server
# Recipe:: ntp
#
# Copyright 2016, Jeff Hallyburton
#
# All rights reserved - Do Not Redistribute
#
#


# Install ntpd
package 'ntp' do
  action :install
end

# Update the clock / hardware clock (you should do this anyway)
execute 'update clock and hardware clock' do
  command 'ntpdate pool.ntp.org && hwclock --syshotc'
end

# stop and disable the chronyd service (RHEL7)
service 'chronyd' do
  case node['platform_version'] 
    when '7'
      action [ :stop, :disable ]
  end
end

# start and enable the ntpd service
service 'ntpd' do
  action [ :start, :enable ]
end  
