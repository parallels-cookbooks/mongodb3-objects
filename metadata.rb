name 'mongodb3-objects'
maintainer 'The Authors'
maintainer_email 'andrei@skopenko.net'
license 'Apache 2.0'
description 'Provides LWRP resources to manage MongoDB 3.x'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.4.5'
source_url 'https://github.com/parallels-cookbooks/mongodb3-objects.git'
issues_url 'https://github.com/parallels-cookbooks/mongodb3-objects/issues'

supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'

depends 'mongodb3'
depends 'mongo_chef_gem'
