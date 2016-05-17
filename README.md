# mongodb3-objects

### Description

This cookbook is a wrapper over the [mongodb3](https://supermarket.chef.io/cookbooks/mongodb3) cookbook. It contains LWRP resources to create:
* [users](https://docs.mongodb.com/manual/tutorial/manage-users-and-roles/)
* [replica sets](https://docs.mongodb.com/manual/core/replication/)
* [sharding database](https://docs.mongodb.com/manual/core/sharded-cluster-components/)
* [sharding collection](https://docs.mongodb.com/v3.0/reference/command/shardCollection/)
* [replica sets for config servers](https://docs.mongodb.com/manual/core/sharded-cluster-config-servers/)
* [routing servers (mongos)](https://docs.mongodb.com/manual/reference/program/mongos/)

### Requirements

#### Platforms

Tested on Centos 6 and 7, but could work on any other Linux.

#### Cookbooks

* [mongodb3](https://supermarket.chef.io/cookbooks/mongodb3)
* [mongo_chef_gem](https://supermarket.chef.io/cookbooks/mongodb3)

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

Creates a replica set with specified members (usually 3).

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|members|Replica set members in format host:port|Array||
|config_server|Set config server settings for replica set|Boolean||

##### mongodb_shard

Add shard to a sharding cluster. This is essentially [addShard](https://docs.mongodb.com/v3.0/reference/method/sh.addShard/) command. The host parameter can be in any of the following forms:
- \[hostname\]
- \[hostname\]:\[port\]
- \[replica-set-name\]/\[hostname\]
- \[replica-set-name\]/\[hostname\]:port

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|shard_endpoint|The hostname of either a standalone database instance or of a replica set. Include the port number if the instance is running on a non-standard port. Include the replica set name if the instance is a replica set.|String|no default|

##### mongodb_sharding_database

Configure sharding for database. This adds `enableSharding` parameter to database configuration.

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|database|Database name|String||

##### mongodb_sharding_collection

Enables a collection for sharding and allows MongoDB to begin distributing data among shards. You must run `mongodb_sharding_database` on a database before using this.

###### Attributes
|Attribute|Description|Type|Default|
|---------|-----------|----|-------|
|collection|Collection name|String||
|shard_key|The index specification document to use as the shard key. The index must exist prior to the shardCollection command, unless the collection is empty. If the collection is empty, in which case MongoDB creates the index prior to sharding the collection. New in version 2.4: The key may be in the form { field : "hashed" }, which will use the specified field as a hashed shard key.|Hash||

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
