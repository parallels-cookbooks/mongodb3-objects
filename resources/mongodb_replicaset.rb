#
# Cookbook Name:: mongodb3-objects
# Resource:: mongodb_replicaset
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

resource_name :mongodb_replicaset

property :replica_set, String, name_property: true
property :members, Array, required: true
property :set_version, Integer, default: 1
property :config_server, [TrueClass, FalseClass], default: false
property :connection_host, String, default: '127.0.0.1'
property :connection_port, Integer, default: 27_017
property :connection_user, [String, nil], default: nil
property :connection_password, [String, nil], default: nil
property :connection_database, String, default: 'admin'

default_action :create

include MongoDbObjects::Helpers

def replicaset_configured?(mongodb_connection_info)
  begin
    client = mongo_connection(mongodb_connection_info)
    db = client.database
    result = db.command(replSetGetStatus: 1)
    return true if result.first['ok'] == 1
  rescue Mongo::Error::OperationFailure => ex
    return true if ex.message =~ /not authorized on admin to execute command/
    return false if ex.message =~ /no replset/
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

  if replicaset_configured?(connection_info)
    Chef::Log.info("Replica set #{new_resource.name} already configured")
  else
    Chef::Log.info('Initializing replica set...')
    begin
      replicaset_config = BSON::Document.new
      replicaset_config['_id'] = new_resource.replica_set
      replicaset_config['version'] = new_resource.set_version
      replicaset_config['configsvr'] = new_resource.config_server unless new_resource.config_server.eql? false
      replicaset_config['members'] = []
      member_id = 0
      new_resource.members.each do |member|
        member['_id'] = member_id
        replicaset_config['members'] << member
        member_id += 1
      end

      Chef::Log.info("Replica set configuration #{replicaset_config}")

      if new_resource.connection_database
        client_nodb = mongo_connection(connection_info)
        client = client_nodb.use(new_resource.connection_database)
      else
        client = mongo_connection(connection_info)
      end
      db = client.database
      db.command('replSetInitiate' => replicaset_config)
      new_resource.updated_by_last_action(true)

    rescue Mongo::Auth::Unauthorized, Mongo::Error => e
      raise "Can't configure replica set #{new_resource.name}:\n#{e}"
    end
  end
end
