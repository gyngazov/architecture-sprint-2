sh.addShard( "Replicaset0/mongodb0-1:27018");
sh.addShard( "Replicaset0/mongodb0-2:27019");
sh.addShard( "Replicaset0/mongodb0-3:27020");
sh.addShard( "Replicaset1/mongodb1-1:27021");
sh.addShard( "Replicaset1/mongodb1-2:27022");
sh.addShard( "Replicaset1/mongodb1-3:27023");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
