#!/bin/bash

# 1 инит конфиг сервера
docker cp js/10.js configSrv:/tmp && docker exec -it configSrv mongosh --port 27017 --f /tmp/10.js

# 2 инит шарда 1
docker cp js/9.js shard1:/tmp && docker exec -it shard1 mongosh --port 27018 --f /tmp/9.js

# 3 инит шарда 2
docker cp js/8.js shard2:/tmp && docker exec -it shard2 mongosh --port 27019 --f /tmp/8.js

# 4 инит роутера
docker cp js/7.js mongos_router:/tmp && docker exec -it mongos_router mongosh --port 27020 --f /tmp/7.js

# 5 вставить юзеров через ендпойнт
ADDR=http://localhost:8080/helloDoc/users

for A in $(seq 32)
do 
    curl -X POST -H 'Content-Type:application/json' \
        -d '{"name":"yswe3r4-'$A'","age":"'$A'"}' $ADDR
done

# 6 пользователей в шарде 1
echo 'пользователей в шарде 1'
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

# 7 пользователей в шарде 2
echo 'пользователей в шарде 2'
docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

