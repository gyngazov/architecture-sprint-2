#!/bin/bash

get_shard_users_count() {
docker compose exec -T $1 mongosh --port $2 --quiet <<EOF
"shard: " + rs.status().set
use somedb
"doc count: " + db.helloDoc.countDocuments()
EOF
}

curl --version &>/dev/null
test $? -eq 127 && echo install curl && exit

# 0 инит конфиг сервера
docker cp js/10.js configSrv:/tmp && docker exec -it configSrv mongosh --port 27017 --f /tmp/10.js

# 1 инит репликасета0
docker cp js/rs0.js mongodb0-1:/tmp && docker exec -it mongodb0-1 mongosh --port 27018 --f /tmp/rs0.js

# 2 инит репликасета1
docker cp js/rs1.js mongodb1-1:/tmp && docker exec -it mongodb1-1 mongosh --port 27021 --f /tmp/rs1.js

# 3 инит роутера
sleep 3
docker cp js/7.js mongos_router:/tmp && docker exec -it mongos_router mongosh --port 27024 --f /tmp/7.js

# 4 вставить юзеров через ендпойнт
ADDR=http://localhost:8080/helloDoc/users

for A in $(seq 100)
do 
    curl -X POST -H 'Content-Type:application/json' \
        -d '{"name":"yswe3r4-'$A'","age":"'$A'"}' $ADDR
done
echo
echo report:

# 5 пользователей в шарде 0
get_shard_users_count mongodb0-1 27018 | grep -oE -e 'shard.*$' -e 'doc.*$'

# 6 пользователей в шарде 1
get_shard_users_count mongodb1-1 27021 | grep -oE -e 'shard.*$' -e 'doc.*$'

