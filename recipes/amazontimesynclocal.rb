#
# Cookbook Name:: amazontimesync
# Recipe:: amazontimesync
#
# Copyright 2017, arvato systems GmbH
#
# All rights reserved - Do Not Redistribute
#

platformfamily = node['platform_family']

# uninstall ntp package if exist
package 'ntp' do
  action :remove
end

# install chrony package
package 'chrony' do
  action :install
end

# update chrony.conf file
if platformfamily == "debian"
  template '/etc/chrony/chrony.conf' do
    source "/home/ubuntu/chef-repo/chef-cookbook-amazontimesync/templates/default/amazontimesync/#{platformfamily}_chrony.conf.erb"
    local true
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
elsif platformfamily == "rhel" || platformfamily == "suse"
  template '/etc/chrony.conf' do
    source '/home/ec2-user/chef-repo/chef-cookbook-amazontimesync/templates/default/amazontimesync/#{platformfamily}_chrony.conf.erb'
    local true
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
end
# start chronyd service
service 'chrony' do
  if platformfamily == "debian"
    service_name 'chrony'  
  elsif platformfamily == "rhel" || platformfamily == "suse"
    service_name 'chronyd'
  end
  action :start
end
