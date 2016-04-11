#
# Cookbook Name:: mongotest
# Recipe:: test_replset
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

node.set['mongodb3']['config']['mongod']['replication']['replSetName'] = 'TestReplSet'

include_recipe 'mongodb3-objects::default'
include_recipe 'mongodb3::package_repo'
include_recipe 'mongodb3::default'

service 'mongod' do
  supports start: true, stop: true, restart: true, status: true
  action [:enable, :start]
end
