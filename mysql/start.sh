docker run --name ss2-mysql -e MYSQL_ROOT_PASSWORD=admin -dit -p 3306:3306 mysql:latest --secure-file-priv=""
docker cp ../entradas ss2-mysql:/var/lib
