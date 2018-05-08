#
# Cookbook Name:: mongotest
# Recipe:: test_mongos
#
# Copyright:: 2016-2017 Parallels International GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

app_info = data_bag_item('keys', 'sharding')

include_recipe 'mongodb3-objects::default'
include_recipe 'mongodb3::package_repo'
node.default['mongodb3']['config']['mongos']['sharding']['configDB'] = "#{app_info['config_relset']}/#{app_info['config_servers'].map { |n| n['host'] }.join(',')}"
node.default['mongodb3']['config']['mongos']['net']['port'] = 27_017
include_recipe 'mongodb3::mongos'

mongodb_shard "ShardReplicaSet/#{app_info['shards_set'].map { |n| n['host'] }.join(',')}"

app_info['shards'].each do |shard|
  mongodb_shard shard['host']
end

mongodb_sharding_database app_info['sharding_database']

mongodb_sharding_collection app_info['sharding_collection'] do
  shard_key('_id' => 1)
end
