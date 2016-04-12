require 'spec_helper'

describe 'mongodb' do
  it 'is listening on port 27019' do
    expect(port(27_019)).to be_listening
  end

  it 'is a running service of mongod' do
    expect(service('mongod')).to be_running
  end

  it 'is a enabled service of mongod' do
    expect(service('mongod')).to be_enabled
  end
end
