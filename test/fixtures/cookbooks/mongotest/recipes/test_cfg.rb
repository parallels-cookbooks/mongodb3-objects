#
# Cookbook Name:: mongotest
# Recipe:: test_cfg
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

app_info = data_bag_item('keys', 'sharding')

node.set['mongodb3']['config']['mongod']['sharding']['clusterRole'] = 'configsvr'
node.set['mongodb3']['config']['mongod']['net']['port'] = 27_019
node.set['mongodb3']['config']['mongod']['replication']['replSetName'] = app_info['config_relset']

include_recipe 'mongodb3-objects::default'
include_recipe 'mongodb3::package_repo'
include_recipe 'mongodb3::default'

service 'mongod' do
  supports start: true, stop: true, restart: true, status: true
  action [:enable, :start]
end
