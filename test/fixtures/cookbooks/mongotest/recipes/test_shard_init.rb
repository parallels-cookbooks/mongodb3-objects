#
# Cookbook Name:: mongotest
# Recipe:: test_cfg_init
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mongotest::test_shard_set'

app_info = data_bag_item('keys', 'sharding')

mongodb_replicaset 'ShardReplicaSet' do
  config_server false
  members app_info['shards_set']
  connection_port 27_018
end
