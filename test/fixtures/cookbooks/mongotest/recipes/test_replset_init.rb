#
# Cookbook Name:: mongotest
# Recipe:: test_replset_init
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mongotest::test_replset'

app_info = data_bag_item('keys', 'replset')

mongodb_replicaset 'TestReplSet' do
  members app_info['replset']
end
