#
# Cookbook Name:: amazontimesync
# Recipe:: amazontimesync
#
# Copyright 2017, arvato systems GmbH
#
# All rights reserved - Do Not Redistribute
#

# uninstall ntp package if exist
package 'ntp' do
  action :remove
end

# install chrony package
package 'chrony' do
  action :install
end

# update chrony.conf file
if node['platform_family'] == "debian"
  template '/etc/chrony/chrony.conf' do
    source '/home/ubuntu/chef-repo/chef-cookbook-amazontimesync/templates/default/amazontimesync/debian_chrony.conf.erb'
    local true
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
elsif node['platform_family'] == "rhel"
  template '/etc/chrony.conf' do
    source '/home/ec2-user/chef-repo/chef-cookbook-amazontimesync/templates/default/amazontimesync/rhel_chrony.conf.erb'
    local true
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end
elsif node['platform_family'] == "suse"
  template '/etc/chrony.conf' do
    source '/home/ec2-user/chef-repo/chef-cookbook-amazontimesync/templates/default/amazontimesync/suse_chrony.conf.erb'
    local true
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
end

# start chronyd service
service 'chrony' do
  if node['platform_family'] == "debian"
    service_name 'chrony'  
  elsif node['platform_family'] == "rhel"
    service_name 'chronyd'
  elsif node['platform_family'] == "suse"
    service_name 'chronyd'
  end
  action :start
end
