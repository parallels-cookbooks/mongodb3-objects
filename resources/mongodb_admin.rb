#
# Cookbook Name:: mongodb3-objects
# Resource:: mongodb_admin
#
# Copyright (C) 2016 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

resource_name :mongodb_admin

property :login, String, name_property: true
property :password, String, required: true
property :connection_host, String, default: '127.0.0.1'
property :connection_port, Integer, default: 27_017

default_action :create

action :create do
  require 'rubygems'
  require 'mongo'
  require 'bson'

  begin
    client = Mongo::Client.new(["#{new_resource.connection_host}:#{new_resource.connection_port}"],
                               user: new_resource.login,
                               password: new_resource.password,
                               database: 'admin',
                               connect_timeout: 5,
                               connect: :direct)
    db = client.database
    Chef::Log.info('Admin already exists')
    return if db['system.users'].find.map { |d| d['user'] }.include? new_resource.login
  rescue Mongo::Auth::Unauthorized
    Chef::Log.info("Admin doesn't exist")
  rescue Mongo::Error::OperationFailure
    Chef::Log.info("Admin doesn't exist")
  end

  Chef::Log.info("Create admin #{new_resource.login}")
  begin
    Chef::Log.info("Init connection to #{new_resource.connection_host}:#{new_resource.connection_port}")
    client = Mongo::Client.new(["#{new_resource.connection_host}:#{new_resource.connection_port}"],
                               database: 'admin',
                               connect_timeout: 5,
                               connect: :direct)
    db = client.database
    db.command(BSON::Document.new(createUser: new_resource.login,
                                  pwd: new_resource.password,
                                  roles: 'root'))
    new_resource.updated_by_last_action(true)
  rescue Mongo::Error::OperationFailure => e
    Chef::Log.info("can't create admin #{new_resource.login}, #{e}")
  end
end
