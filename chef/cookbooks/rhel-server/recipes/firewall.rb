#
# Cookbook Name:: rhel-server
# Recipe:: epel
#
# Copyright 2016, Jeff Hallyburton
#

# Stop and disable firewalld or iptables in RHEL
service 'firewall' do
    case node['platform']
        when 'centos', 'redhat', 'fedora'
            case node['platform_version']
                when '5', '6'
                    service_name 'iptables'
                else
                    service_name 'firewalld'
            end
                action [ :stop, :disable ]
    end
end



