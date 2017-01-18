#
# Cookbook Name:: mongodb3-objects
# Resource:: mongodb_shard
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

resource_name :mongodb_shard

property :shard_endpoint, kind_of: String, name_attribute: true
property :connection_host, String, default: '127.0.0.1'
property :connection_port, Integer, default: 27_017
property :connection_user, [String, nil], default: nil
property :connection_password, [String, nil], default: nil
property :connection_database, String, default: 'admin'

default_action :create

include MongoDbObjects::Helpers

def shard_exists?(mongodb_connection_info, shard)
  client = mongo_connection(mongodb_connection_info)
  db = client.database
  shards = db.command(listShards: 1)
  return shards.first['shards'].map { |k| k['host'] }.include? shard
rescue Mongo::Error::OperationFailure
  return false
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

  shard_ep = new_resource.shard_endpoint
  if shard_exists?(connection_info, shard_ep)
    Chef::Log.info("Shard #{shard_ep} already exists.")
  else
    Chef::Log.info("Add shard #{shard_ep} to cluster.")
    begin
      client = mongo_connection(connection_info)
      db = client.database
      db.command(BSON::Document.new(addShard: shard_ep, name: shard_ep.split('/').first))
      new_resource.updated_by_last_action(true)
    rescue Mongo::Auth::Unauthorized, Mongo::Error => e
      raise "Can't add shard #{shard_ep}:\n#{e}"
    end
  end
end
