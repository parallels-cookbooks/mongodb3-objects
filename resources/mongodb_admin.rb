#
# Cookbook Name:: mongodb3-objects
# Resource:: mongodb_admin
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
                               connect_timeout: 5,
                               connect: :direct)
    db = client.database
    Chef::Log.info('Administrator account already exists.')
    return if db['system.users'].find.map { |d| d['user'] }.include? new_resource.login
  rescue Mongo::Auth::Unauthorized, Mongo::Error::OperationFailure
    Chef::Log.info("Admin doesn't exist")
  end

  Chef::Log.info("Create administrator account #{new_resource.login}")
  begin
    Chef::Log.info("Initiate connection to #{new_resource.connection_host}:#{new_resource.connection_port}")
    client = Mongo::Client.new(["#{new_resource.connection_host}:#{new_resource.connection_port}"],
                               connect_timeout: 5,
                               connect: :direct)
    db = client.database
    db.command(BSON::Document.new(createUser: new_resource.login,
                                  pwd: new_resource.password,
                                  roles: ['root']))
    new_resource.updated_by_last_action(true)
  rescue Mongo::Auth::Unauthorized, Mongo::Error::OperationFailure => e
    raise "Can't create admin #{new_resource.login}:\n#{e}"
  end
end
