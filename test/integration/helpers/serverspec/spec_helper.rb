require 'serverspec'
require 'rubygems'
require 'mongo'
require 'bson'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end

def mongo_connection(mongo_connection_info)
  client = Mongo::Client.new(["#{mongo_connection_info[:host]}:#{mongo_connection_info[:port]}"],
                             database: mongo_connection_info[:database],
                             user: mongo_connection_info[:user],
                             password: mongo_connection_info[:password],
                             connect_timeout: 5,
                             connect: :direct)
  client
end

def user_exists?(mongo_connection_info, user, password, database)
  begin
    mongo_connection_check = mongo_connection_info.clone
    mongo_connection_check[:user] = user
    mongo_connection_check[:password] = password
    mongo_connection_check[:database] = database
    client = mongo_connection(mongo_connection_check)
    db = client.database
    db['system.users'].find
  rescue Mongo::Auth::Unauthorized
    return false
  rescue Mongo::Error::OperationFailure
    return false
  end
  true
end

def replicaset_configured?(mongodb_connection_info)
  begin
    client = mongo_connection(mongodb_connection_info)
    db = client.database
    result = db.command(replSetGetStatus: 1)
    return false if result.first['ok'] == 0
  rescue Mongo::Error::OperationFailure
    return false
  end
  true
end

def sharding_db_enabled?(mongodb_connection_info, database)
  begin
    client = mongo_connection(mongodb_connection_info)
    client_config = client.use('config')
    db = client_config.database
    return true if db[:databases].find(partitioned: true).map { |d| d['_id'] }.include? database
  rescue Mongo::Error::OperationFailure
    return false
  end
  false
end

def sharding_collection_enabled?(mongodb_connection_info, collection)
  begin
    client = mongo_connection(mongodb_connection_info)
    client_config = client.use('config')
    db = client_config.database
    return true if db[:collections].find.map { |d| d['_id'] }.include? collection
  rescue Mongo::Error::OperationFailure
    return false
  end
  false
end

def shard_exists?(mongodb_connection_info, shard)
  begin
    client = mongo_connection(mongodb_connection_info)
    db = client.database
    shards = db.command(listShards: 1)
    return true if shards.first['shards'].map { |k| k['host'] }.include? shard
  rescue Mongo::Error::OperationFailure
    return false
  end
  false
end

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
