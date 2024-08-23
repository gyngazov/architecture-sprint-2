rs.initiate(
    {
      _id : "shard1",
      members: [ 
          { _id : 0, host : "mongodb0-1:27018" },
          { _id : 1, host : "mongodb0-2:27019" }, 
          { _id : 2, host : "mongodb0-3:27020" }
      ]
    }
);
