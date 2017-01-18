#
# Cookbook Name:: mongotest
# Recipe:: test_cfg_init
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

include_recipe 'mongotest::test_cfg'

app_info = data_bag_item('keys', 'sharding')

mongodb_replicaset app_info['config_relset'] do
  config_server true
  members app_info['config_servers']
  connection_port 27_019
end
