require 'spec_helper'

describe 'mongodb' do
  it 'is listening on port 27018' do
    expect(port(27_018)).to be_listening
  end

  it 'is a running service of mongod' do
    expect(service('mongod')).to be_running
  end

  it 'is a enabled service of mongod' do
    expect(service('mongod')).to be_enabled
  end
end

connection_info = {
  host: '127.0.0.1',
  port: 27_018,
  database: 'admin',
}

describe 'mongodb replica set' do
  it 'has been configured ' do
    expect(replicaset_configured?(connection_info)).to eq(true)
  end
end
