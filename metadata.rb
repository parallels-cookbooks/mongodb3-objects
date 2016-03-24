name 'mongodb3-objects'
maintainer 'The Authors'
maintainer_email 'akhadiev@parallels.com'
license 'Apache2'
description 'Provides LWRP resources to manage mongodb3'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
source_url 'https://git.prls.net/scm/cook/mongodb3-objects.git'
issues_url ''

depends 'mongodb3', '~> 5.0'
depends 'mongo_chef_gem', '~> 0.1.0'
