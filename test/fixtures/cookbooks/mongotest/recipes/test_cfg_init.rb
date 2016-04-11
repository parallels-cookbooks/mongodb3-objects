#
# Cookbook Name:: mongotest
# Recipe:: test_cfg_init
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mongotest::test_cfg'

app_info = data_bag_item('keys', 'sharding')

mongodb_replicaset app_info['config_relset'] do
  config_server true
  members app_info['config_servers']
  connection_port 27_019
end
