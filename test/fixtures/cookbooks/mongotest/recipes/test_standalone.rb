#
# Cookbook Name:: mongotest
# Recipe:: create_user
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

include_recipe 'mongodb3-objects::standalone'

app_info = data_bag_item('keys', 'standalone')

mongodb_admin app_info['clusters']['test']['user_admin_login'] do
  password app_info['clusters']['test']['user_admin_password']
end

# Creating users
app_info['clusters']['test']['databases'].each do |db|
  db['users'].each do |user|
    mongodb_user user['login'] do
      password user['password']
      roles user['roles']
      database db['name']
      connection_user app_info['clusters']['test']['user_admin_login']
      connection_password app_info['clusters']['test']['user_admin_password']
    end
  end
end

mongodb_collection_index 'firstkey_1_secondkey_-1' do
  collection 'coll'
  database 'database1'
  index key: { firstkey: 1, secondkey: -1 }, unique: 1
  connection_user app_info['clusters']['test']['user_admin_login']
  connection_password app_info['clusters']['test']['user_admin_password']
end
