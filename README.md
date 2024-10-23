# docker-common

## Mysql replication

### Mysql Master
Login mysql
```
mysql -uroot -p
```
Show binary log
```
SHOW BINARY LOG STATUS\G;
SHOW MASTER STATUS;
```
Create user replication
```
CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
```


### Mysql Slave
Show replica
```
SHOW REPLICA STATUS\G;
```

Setup relica source
```
CHANGE REPLICATION SOURCE TO SOURCE_HOST='mysql',
SOURCE_PORT=3306,
SOURCE_USER='repl',
SOURCE_PASSWORD='password',
SOURCE_LOG_FILE='mysql-bin.000003',
SOURCE_LOG_POS=858,
SOURCE_CONNECT_RETRY=10,
GET_SOURCE_PUBLIC_KEY=1;
```

Start replica
```
START REPLICA;
```
Stop replica
```
STOP REPLICA;
```
