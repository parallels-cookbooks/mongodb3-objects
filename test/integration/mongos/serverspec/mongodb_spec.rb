require 'spec_helper'

connection_info = {
  host: '127.0.0.1',
  port: 27_017,
  database: 'admin'
}

describe 'mongodb sharding' do
  it 'has shard 172.16.20.13' do
    expect(shard_exists?(connection_info, '172.16.20.13')).to eq(true)
  end

  it 'has shard 172.16.20.14' do
    expect(shard_exists?(connection_info, '172.16.20.13')).to eq(true)
  end

  it "has sharded database 'testdb'" do
    expect(sharding_db_enabled?(connection_info, 'testdb')).to eq(true)
  end

  it "has sharded collections 'testcoll'" do
    expect(sharding_collection_enabled?(connection_info, 'testdb.testcoll')).to eq(true)
  end
end

describe 'mongos' do
  it 'is listening on port 27017' do
    expect(port(27_017)).to be_listening
  end

  it 'is a running service of mongos' do
    expect(service('mongos')).to be_running
  end
end
