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
