# mongodb3-objects

### Description

This cookbook is a wrapper over the [mongodb3](https://supermarket.chef.io/cookbooks/mongodb3) cookbook. It contains lwrp resources to create:
* users
* replica sets
* shards (planned)
* configuration servers (planned)
* routing servers (planned)

### Requirements

#### Platforms

Tested on Centos 6 only, but could work on any other Linux.

#### Cookbooks

* [mongodb3](https://supermarket.chef.io/cookbooks/mongodb3), ~> 5.0

### Resources

##### mongodb_admin

Creates administrator account. If authentication mechanism was enabled in configuration already, only request from localhost to create administrator user will work. See [this](https://docs.mongodb.org/manual/tutorial/enable-authentication/) and [this](https://docs.mongodb.org/manual/core/security-users/#localhost-exception). Login is arbitrary.

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|login|Login name for administrator account|String||
|password|Password for administrator account|String||


##### mongodb_user

Creates a user account in specified database with specified role. In MongoDB database can be absent till some data is written. Users are stored in 'admin' database. To choose appropriate role see [built-in roles](https://docs.mongodb.org/manual/reference/built-in-roles/).

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|login|User name|String||
|password|User password|String||
|roles|Roles to assign|Hash||
|database|User database|String|admin|

##### mongodb_replicaset

Creates a replica set with specified members.

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|members|Replica set members in format host:port|Array||
|config_server|Set config server settings for replica set|Boolean||

### Examples

If MongoDB is already installed just use

    include_recipe 'mongodb3-objects::default'

to install `mongo` and `bson` gems. After that LWRPs can be used.

To install standalone MongoDB use

    include_recipe 'mongodb3-objects::standalone'

Also you may see examples in fixture cookbook: test/fixtures/cookbooks/mongotest/recipes.

### Authors

TBD
