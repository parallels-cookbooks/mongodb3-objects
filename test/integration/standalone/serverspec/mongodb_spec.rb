require 'spec_helper'

connection_info = {
  host: '127.0.0.1',
  port: 27_017,
  user: 'siteRootAdmin',
  password: 'pass',
  database: 'admin',
}

describe 'user1' do
  it 'should exist in database1' do
    expect(user_exists?(connection_info, 'user1', 'pass1', 'database1')).to eq(true)
  end
end

describe 'user2' do
  it 'should exist in database2' do
    expect(user_exists?(connection_info, 'user2', 'pass2', 'database2')).to eq(true)
  end
end

describe 'user3' do
  it 'should exist in database1' do
    expect(user_exists?(connection_info, 'user3', 'pass3', 'database1')).to eq(true)
  end
end

describe 'user3' do
  it 'should exist in database2' do
    expect(user_exists?(connection_info, 'user3', 'pass3', 'database2')).to eq(true)
  end
end

describe 'index in database1 and collection coll' do
  it 'should exist' do
    expect(mongodb_collection_index_exists?(connection_info, 'database1', 'coll', 'firstkey_1_secondkey_-1')).to eq(true)
  end
end
