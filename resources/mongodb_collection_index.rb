#
# Cookbook Name:: mongodb3-objects
# Resource:: mongodb_collection_index
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

resource_name :mongodb_collection_index

property :name, kind_of: String, name_attribute: true
property :collection, kind_of: String, required: true
property :database, kind_of: String, required: true
property :index, kind_of: Hash, required: true
property :connection_host, String, default: '127.0.0.1'
property :connection_port, Integer, default: 27_017
property :connection_user, [String, nil], default: nil
property :connection_password, [String, nil], default: nil
property :connection_database, String, default: 'admin'

default_action :create

include MongoDbObjects::Helpers

def mongodb_collection_index_exists?(mongodb_connection_info, database, collection, name)
  begin
    client = mongo_connection(mongodb_connection_info)
    client_db = client.use(database)
    db = client_db.database
    inds = db.command(BSON::Document.new(listIndexes: collection)).first
    return true if inds[:cursor][:firstBatch].map { |d| d[:name] }.include? name
  rescue Mongo::Error::OperationFailure
    return false
  end
  false
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

  if mongodb_collection_index_exists?(connection_info, new_resource.database, new_resource.collection, new_resource.name)
    Chef::Log.warn("Index #{new_resource.name} for collection #{new_resource.collection} already exists")
  else
    Chef::Log.warn("Create index #{new_resource.name} for collection #{new_resource.collection}")
    begin
      client = mongo_connection(connection_info)
      client_db = client.use(database)
      db = client_db.database
      new_resource.index['name'] = new_resource.name
      db.command(BSON::Document.new(createIndexes: new_resource.collection, indexes: [new_resource.index]))
      new_resource.updated_by_last_action(true)
    rescue Mongo::Auth::Unauthorized, Mongo::Error => e
      raise "Can't create index #{new_resource.name} for collection #{new_resource.collection}:\n#{e}"
    end
  end
end
