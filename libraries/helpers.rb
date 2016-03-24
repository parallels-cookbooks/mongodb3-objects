#
# Cookbook Name:: mongodb3-objects
# Libraries:: helpers
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

module MongoDbObjects
  # Helper module
  module Helpers
    def mongo_connection(mongo_connection_info)
      require 'rubygems'
      require 'mongo'
      require 'bson'
      Chef::Log.info("Init connection to #{mongo_connection_info[:host]}:#{mongo_connection_info[:port]}")
      Mongo::Client.new(["#{mongo_connection_info[:host]}:#{mongo_connection_info[:port]}"],
                       database: mongo_connection_info[:database],
                       user: mongo_connection_info[:user],
                       password: mongo_connection_info[:password],
                       connect_timeout: 5,
                       connect: :direct)
    end

    def sharding_collection_enabled?(collection)
      begin
        client = mongo_connection(@mongodb_connection_info)
        client_config = client.use('config')
        db = client_config.database
        return false unless db[:collections].find.map { |d| d['_id'] }.include? collection
      rescue Mongo::Error::OperationFailure
        return false
      end
      true
    end

    def replicaset_configured?
      begin
        client = mongo_connection(@mongodb_connection_info)
        db = client.database
        result = db.command(replSetGetStatus: 1)
        return false if result.first['ok'] == 0
      rescue Mongo::Error::OperationFailure => ex
        return false if ex.message =~ /no replset/
      end
      true
    end

    def shard_exists?(shard)
      begin
        client = mongo_connection(@mongodb_connection_info)
        db = client.database
        shards = db.command(listShards: 1)
        return false unless shards.first['shards'].map { |k| k['_id'] }.include? shard
      rescue Mongo::Error::OperationFailure
        return false
      end
      true
    end

    def sharding_db_enabled?(database)
      begin
        client = mongo_connection(@mongodb_connection_info)
        client_config = client.use('config')
        db = client_config.database
        return false unless db[:databases].find(partitioned: true).map { |d| d['_id'] }.include? database
      rescue Mongo::Error::OperationFailure
        return false
      end
      true
    end
  end
end
