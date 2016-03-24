#
# Cookbook Name:: mongodbtest
# Recipe:: standalone
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

node.set['mongodb3']['config']['mongod']['security']['authorization'] = 'enabled'

include_recipe 'mongodb3::package_repo'
include_recipe 'mongodb3::default'

service 'mongod' do
  supports start: true, stop: true, restart: true, status: true
  action [:enable, :start]
end

include_recipe 'mongodb3-objects::default'
