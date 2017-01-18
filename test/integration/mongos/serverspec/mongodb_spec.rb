require 'spec_helper'

connection_info = {
  host: '127.0.0.1',
  port: 27_017,
  database: 'admin',
}

describe 'mongodb sharding' do
  it 'has ShardReplicaSet/172.16.20.26:27018,172.16.20.27:27018,172.16.20.28:27018' do
    expect(shard_exists?(connection_info, 'ShardReplicaSet/172.16.20.26:27018,172.16.20.27:27018,172.16.20.28:27018')).to eq(true)
  end

  it 'has shard 172.16.20.21' do
    expect(shard_exists?(connection_info, '172.16.20.21:27018')).to eq(true)
  end

  it 'has shard 172.16.20.22' do
    expect(shard_exists?(connection_info, '172.16.20.22:27018')).to eq(true)
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
end
