#
# Cookbook Name:: mongodb3-objects
# Resource:: mongodb_user
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

resource_name :mongodb_user

property :login, String, name_property: true
property :password, String, required: true
property :roles, Array, required: true
property :database, String, default: ''
property :connection_host, String, default: '127.0.0.1'
property :connection_port, Integer, default: 27_017
property :connection_user, String, required: true
property :connection_password, String, required: true
property :connection_database, String, default: 'admin'

default_action :create

include MongoDbObjects::Helpers

def user_exists?(mongodb_connection_info, user, password, database = '')
  begin
    if !database
      client = mongo_connection(mongodb_connection_info)
    else
      mongo_connection_check = mongodb_connection_info.clone
      mongo_connection_check[:user] = user
      mongo_connection_check[:password] = password
      mongo_connection_check[:database] = database
      client = mongo_connection(mongo_connection_check)
      client.database.collection_names
      return true
    end
    db = client.database
    return false unless db['system.users'].find.map { |d| d['user'] }.include? user
  rescue Mongo::Auth::Unauthorized
    return false
  rescue Mongo::Error::OperationFailure
    return false
  end
  true
end

action :create do
  require 'rubygems'
  require 'mongo'
  require 'bson'

  connection_info = {
    host: new_resource.connection_host,
    port: new_resource.connection_port,
    user: new_resource.connection_user,
    password: new_resource.connection_password,
    database: new_resource.connection_database
  }
  if user_exists?(connection_info, new_resource.login, new_resource.password, new_resource.database)
    Chef::Log.info("user #{new_resource.login} already exists")
  else
    Chef::Log.info("Create user #{new_resource.login}")
    begin
      if new_resource.database
        client_nodb = mongo_connection(connection_info)
        client = client_nodb.use(new_resource.database)
      else
        client = mongo_connection(connection_info)
      end
      db = client.database
      db.command(BSON::Document.new(createUser: new_resource.login,
                                    pwd: new_resource.password,
                                    roles: new_resource.roles))
      new_resource.updated_by_last_action(true)
    rescue Mongo::Error::OperationFailure => e
      Chef::Log.info("can't create user #{new_resource.login}, #{e}")
    end
  end
end
