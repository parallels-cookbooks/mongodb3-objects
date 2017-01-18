#
# Cookbook Name:: mongodb3-objects
# Resource:: mongodb_sharding_collection
#
# Copyright (c) 2016-2017 The Authors, All Rights Reserved.
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

resource_name :mongodb_sharding_collection

property :collection, kind_of: String, name_attribute: true
property :shard_key, kind_of: Hash, required: true
property :connection_host, String, default: '127.0.0.1'
property :connection_port, Integer, default: 27_017
property :connection_user, [String, nil], default: nil
property :connection_password, [String, nil], default: nil
property :connection_database, String, default: 'admin'

default_action :create

include MongoDbObjects::Helpers

def sharding_collection_enabled?(mongodb_connection_info, collection)
  begin
    client = mongo_connection(mongodb_connection_info)
    client_config = client.use('config')
    db = client_config.database
    return false unless db[:collections].find.map { |d| d['_id'] }.include? collection
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
    database: new_resource.connection_database,
  }

  if sharding_collection_enabled?(connection_info, new_resource.collection)
    Chef::Log.info("Sharding for collection #{new_resource.collection} already enabled")
  else
    Chef::Log.info("Create sharding collection #{new_resource.collection}")
    begin
      client = mongo_connection(connection_info)
      db = client.database
      db.command(BSON::Document.new(shardCollection: new_resource.collection, key: new_resource.shard_key))
      new_resource.updated_by_last_action(true)
    rescue Mongo::Auth::Unauthorized, Mongo::Error => e
      raise "Can't enable sharding for collection #{new_resource.collection}:\n#{e}"
    end
  end
end
