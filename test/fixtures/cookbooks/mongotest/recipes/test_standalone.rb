#
# Cookbook Name:: mongotest
# Recipe:: create_user
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
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
