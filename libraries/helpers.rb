#
# Cookbook Name:: mongodb3-objects
# Libraries:: helpers
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
