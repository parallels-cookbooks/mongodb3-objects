# mongodb3-objects

### Description

This cookbook is a wrapper over the [mongodb3](https://supermarket.chef.io/cookbooks/mongodb3) cookbook. It contains lwrp resources to create:
* users
* replica sets
* sharding database
* sharding collection
* replica sets for config servers
* routing servers

### Requirements

#### Platforms

Tested on Centos 6 and 7, but could work on any other Linux.

#### Cookbooks

* [mongodb3](https://supermarket.chef.io/cookbooks/mongodb3), ~> 5.0

### Resources

##### mongodb_admin

Creates administrator account. If authentication mechanism was enabled in configuration already, only request from localhost to create administrator user will work. See [this](https://docs.mongodb.org/manual/tutorial/enable-authentication/) and [this](https://docs.mongodb.org/manual/core/security-users/#localhost-exception). Login is mandatory.

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

##### mongodb_shard

Add shard to sharding cluster.

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|shard_endpoint|Shard hostname or endpoint in case of replica set|String||
|port|Mongodb port on Shard|Integer|27018|
|replicaset|Switch to add replica set as shard|Boolean|false|

##### mongodb_sharding_database

Configure sharding for database.

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|database|Database name|String||

##### mongodb_sharding_collection

Configure sharding for collection.

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|collection|Collection name|String||
|shard_key|Sharding key for collection|Hash||

### Examples

If MongoDB is already installed just use

    include_recipe 'mongodb3-objects::default'

to install `mongo` and `bson` gems. After that LWRPs can be used.

To install standalone MongoDB use

    include_recipe 'mongodb3-objects::standalone'

Also you may see examples in fixture cookbook: test/fixtures/cookbooks/mongotest/recipes.


### Authors
* Author:: Andrey Scopenco (ascopenco@parallels.com)
* Author:: Azat Khadiev (akhadiev@parallels.com)
