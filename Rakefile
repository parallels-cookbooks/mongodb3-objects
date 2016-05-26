#!/usr/bin/env rake

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'
require 'chef-dk/cli'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
      chef_version: '12.6.0'
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each(&:destroy)
    # replset-el7
    Kitchen::Config.new.instances.get('replset1-el7').converge
    Kitchen::Config.new.instances.get('replset2-el7').converge
    Kitchen::Config.new.instances.get('replset-hidden-el7').converge
    Kitchen::Config.new.instances.get('replset3-el7').converge
    Kitchen::Config.new.instances.get('replset1-el7').verify
    Kitchen::Config.new.instances.get('replset2-el7').verify
    Kitchen::Config.new.instances.get('replset-hidden-el7').verify
    Kitchen::Config.new.instances.get('replset3-el7').verify
    Kitchen::Config.new.instances.each(&:destroy)
    # sharding-el7
    Kitchen::Config.new.instances.get('cfg1-el7').converge
    Kitchen::Config.new.instances.get('cfg2-el7').converge
    Kitchen::Config.new.instances.get('cfg3-el7').converge
    Kitchen::Config.new.instances.get('shard1-el7').converge
    Kitchen::Config.new.instances.get('shard2-el7').converge
    Kitchen::Config.new.instances.get('shard-set1-el7').converge
    Kitchen::Config.new.instances.get('shard-set2-el7').converge
    Kitchen::Config.new.instances.get('shard-set3-el7').converge
    Kitchen::Config.new.instances.get('mongos-el7').converge
    Kitchen::Config.new.instances.get('cfg1-el7').verify
    Kitchen::Config.new.instances.get('cfg2-el7').verify
    Kitchen::Config.new.instances.get('cfg3-el7').verify
    Kitchen::Config.new.instances.get('shard1-el7').verify
    Kitchen::Config.new.instances.get('shard2-el7').verify
    Kitchen::Config.new.instances.get('shard-set1-el7').verify
    Kitchen::Config.new.instances.get('shard-set2-el7').verify
    Kitchen::Config.new.instances.get('shard-set3-el7').verify
    Kitchen::Config.new.instances.get('mongos-ci-el7').verify
    Kitchen::Config.new.instances.each(&:destroy)
  end
end

# Default
task default: ['style', 'spec', 'integration:vagrant']
