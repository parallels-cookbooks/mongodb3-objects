#
# Cookbook Name:: mongodb3-objects
# Resource:: mongodb_shard_replicaset
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

resource_name :mongodb_shard_replicaset

property :shard_endpoint, String, name_property: true
property :port, Integer, default: 27_018
property :connection_host, String, default: '127.0.0.1'
property :connection_port, Integer, default: 27_017
property :connection_user, String, default: nil
property :connection_password, String, default: nil
property :connection_database, String, default: 'admin'

default_action :create

include MongoDbObjects::Helpers

def shard_set_exists?(mongodb_connection_info, host)
  begin
    client = mongo_connection(mongodb_connection_info)
    db = client.database
    shards = db.command(listShards: 1)
    return false unless shards.first['shards'].map { |k| k['host'] }.include? host
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

  if shard_set_exists?(connection_info, new_resource.shard_endpoint)
    Chef::Log.info('Shard already added')
  else
    Chef::Log.info("Add shard #{new_resource.shard_endpoint}")
    begin
      client = mongo_connection(connection_info)
      db = client.database
      name = new_resource.shard_endpoint.split('/').first
      db.command(BSON::Document.new(addShard: new_resource.shard_endpoint, name: name))
      new_resource.updated_by_last_action(true)
    rescue Mongo::Error::OperationFailure => e
      Chef::Log.info("can't add shard #{new_resource.shard_endpoint}, #{e}")
    end
  end
end
