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
  end
end
