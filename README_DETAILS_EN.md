# SequoiaDB - Docker container based cluser deployment tutorial

To facilitate a quick user experience, SequoiaDB provides Docker-based cluseter deployment.   
This page describes how to deploy SequoiaDB distributed cluster in Docker environment.


# 1.0 Cluster Configuration

We will deploy a multi-nodes, highly available SequoiaDB cluster in six containers as follows:


| Hostname | IP | Partition Group | Software Version |
| --- | --- |  --- | --- |
| Coord | [assigned by docker]:11810 | SYSCoord | SequoiaDB 3.2.3 |
| Catalog | [assigned by docker]:11800 | SYSCatalogGroup | SequoiaDB 3.2.3 |
| Data1 | [assigned by docker]:11820 | group1 | SequoiaDB 3.2.3 |
| Data2 | [assigned by docker]:11820 | group1 | SequoiaDB 3.2.3 |
| Data3 | [assigned by docker]:11820 | group1 | SequoiaDB 3.2.3 |
| Data1 | [assigned by docker]:11830 | group2 | SequoiaDB 3.2.3 |
| Data2 | [assigned by docker]:11830 | group2 | SequoiaDB 3.2.3 |
| Data3 | [assigned by docker]:11830 | group2 | SequoiaDB 3.2.3 |
| Data1 | [assigned by docker]:11840 | group3 | SequoiaDB 3.2.3 |
| Data2 | [assigned by docker]:11840 | group3 | SequoiaDB 3.2.3 |
| Data3 | [assigned by docker]:11840 | group3 | SequoiaDB 3.2.3 |
| MySQL instance | [assigned by docker]:3310 | - | SequoiaSQL-MySQL 3.2.3 |   
   
The cluster consists of a coordinator node, a catalog node, three data groups with three replica data nodes per group, and a MySQL instance node.   


## 2.0 Environment

*OS :*  Ubuntu 18   
*Docker Version :* 18.09.7  
*Docker Compose Version:* 1.25.3   
*Database Version :* SequoiaDB 3.2.3   
*MySql Client:* Sequoiasql-mysql
*Cluster Deployment :* 1 coordinator, 1 catalog, 3 data nodes, and 1 MySQL instance   
   
## 2.1 Docker Installation   
#### 2.1.1 Docker
For Docker installation on different platforms refer to Docker installation guide [Docker Install](https://docs.docker.com/install/).
```
  sudo apt-get install -y docker.io
```

#### 2.1.2 Docker-compose
Docker compose is a tool for defining and deploying multi-container Docker application defined in a YAML file
(i.e: [docker-compose.yaml](/docker-compose.yaml)).   
The installation instruction for different platforms can be found [here](https://docs.docker.com/compose/install/).

```
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

#### 2.1.3 MySql client
Install MySQL client (if it's not already installed)
```
  sudo apt install mysql-client-core-5.7 
```

## 3.0 SequoiaDB Distributed Cluster Deployment
Sequoiadb cluster configruration is defined "sequoiadb_containers/docker-compose.yaml".

There are two options to download the required package.
###### Option 1. Clone this repo
```
  git clone git@github.com:SequoiaDB/sequoiadb_containers.git
```

##### Option 2: Download the following files manually (keep the same directory structure)
```
docker-compose.yaml
scripts/startup.sh
scripts/coord_startup.sh
scripts/mysql_startup.sh
```

### 3.1 Deploy the sequoiadb cluster
The `docker-compose up` command will:   
    - download images from docker hup if there are not found locally   
    - create required containers.   
    - start the containers.   
    - initialize sequoiadb cluster and mysql instance.   
1. Deploy the cluster
```
  cd sequoiadb_containers  (or to the directory where docker-compose.yaml file is downloaded)
  sudo docker-compose up -d
```

2. Check the status of cluster
```
$ sudo docker-compose ps
           Name                         Command               State           Ports         
--------------------------------------------------------------------------------------------
sequoiadb_containers_catalog_1   sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_coord_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data1_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data2_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data3_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_mysql_1     sh -c chmod +x /startup.sh ...   Up      0.0.0.0:3310->3310/tcp
```

3. Wait for the cluster to be deployed and mysql connects to the coordinator node. Cluster status can be checked as follows.
 
```
# Check coordinator logs
$ sudo docker-compose logs coord
...
...
coord_1    | ************ Deploy SequoiaDB ************************
coord_1    | Create catalog: catalog:11800
coord_1    | Create coord:   coord:11810
coord_1    | Create data:    data1:11820
coord_1    | Create data:    data2:11820
coord_1    | Create data:    data3:11820
coord_1    | Create data:    data1:11830
coord_1    | Create data:    data2:11830
coord_1    | Create data:    data3:11830
coord_1    | Create data:    data1:11840
coord_1    | Create data:    data2:11840
coord_1    | Create data:    data3:11840
coord_1    | SDB Cluster successfully created.


# Check mysql logs
$ sudo docker-compose logs mysql
...
...
mysql_1    | >>> Waiting for COORD node to come up at (coord:11810)...
mysql_1    | >>> Waiting for COORD node to come up at (coord:11810)...
mysql_1    | >>> Waiting for COORD node to come up at (coord:11810)...
mysql_1    | Successfully reached COORD node at (coord:11810)
mysql_1    | COMMAND: /init.sh --port=3310 --coord=coord:11810
mysql_1    | Creating SequoiaSQL instance: MySQLInstance
mysql_1    | Modify configuration file and restart the instance: MySQLInstance
mysql_1    | Restarting instance: MySQLInstance
mysql_1    | Opening remote access to user root
mysql_1    | Restarting instance: MySQLInstance
mysql_1    | Instance MySQLInstance is created on port 3310, default user is root
mysql_1    | Init command returned: 0

```

### 3.2 Verify MySQL Connection

```shell
$ mysql -h 127.0.0.1 -P 3310 -u root
```

```shell 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.7.25 Source distribution

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

Verify SequoiaDB configurations:
```

mysql> show variables like 'sequoiadb%';
+---------------------------------------+-------------+
| Variable_name                         | Value       |
+---------------------------------------+-------------+
| sequoiadb_bulk_insert_size            | 2000        |
| sequoiadb_conn_addr                   | coord:11810 |
| sequoiadb_debug_log                   | OFF         |
| sequoiadb_execute_only_in_mysql       | OFF         |
| sequoiadb_optimizer_select_count      | ON          |
| sequoiadb_password                    |             |
| sequoiadb_replica_size                | 1           |
| sequoiadb_selector_pushdown_threshold | 30          |
| sequoiadb_use_autocommit              | ON          |
| sequoiadb_use_bulk_insert             | ON          |
| sequoiadb_use_partition               | ON          |
| sequoiadb_user                        |             |
+---------------------------------------+-------------+
12 rows in set (0.01 sec)


mysql> show storage engines;
+--------------------+---------+----------------------------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                                          | Transactions | XA   | Savepoints |
+--------------------+---------+----------------------------------------------------------------------------------+--------------+------+------------+
| SequoiaDB          | DEFAULT | SequoiaDB storage engine(Community). Plugin: eebcb4f, Driver: 3.2.3, BuildTime:  | YES          | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                                            | NO           | NO   | NO         |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                                               | NO           | NO   | NO         |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears)                   | NO           | NO   | NO         |
| MyISAM             | YES     | MyISAM storage engine                                                            | NO           | NO   | NO         |
| CSV                | YES     | CSV storage engine                                                               | NO           | NO   | NO         |
| ARCHIVE            | YES     | Archive storage engine                                                           | NO           | NO   | NO         |
| InnoDB             | YES     | Supports transactions, row-level locking, and foreign keys                       | YES          | YES  | YES        |
| FEDERATED          | NO      | Federated MySQL storage engine                                                   | NULL         | NULL | NULL       |
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables                        | NO           | NO   | NO         |
+--------------------+---------+----------------------------------------------------------------------------------+--------------+------+------------+
10 rows in set (0.00 sec)
```

### 3.3 Test

Users can create databases and tables using MySQL commands：
```
mysql> create database sample;
Query OK, 1 row affected (0.01 sec)

mysql> use sample;
Database changed
mysql>  create table t1 (c1 int);
Query OK, 0 rows affected (0.47 sec)

mysql> show table status;
+------+-----------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+-------------+-------------+------------+-------------+----------+----------------+---------+
| Name | Engine    | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time | Update_time | Check_time | Collation   | Checksum | Create_options | Comment |
+------+-----------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+-------------+-------------+------------+-------------+----------+----------------+---------+
| t1   | SequoiaDB |      10 | Fixed      |    0 |              0 |           0 |   8796093022208 |       131072 |         0 |           NULL | NULL        | NULL        | NULL       | utf8mb4_bin |     NULL |                |         |
+------+-----------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+-------------+-------------+------------+-------------+----------+----------------+---------+
1 row in set (0.03 sec)
```


## 4.0 Cluster Management
### 4.1 Stop/Start cluster
After sequoiadb cluster is created with `up` command, it can be stopped and started as follows.    
Note that `stop` command will not destory the containers, hence no data will be lost.  

#### 4.1.1 Stop

```shell
$ sudo docker-compose stop
Stopping sequoiadb_containers_mysql_1   ... done
Stopping sequoiadb_containers_coord_1   ... done
Stopping sequoiadb_containers_data2_1   ... done
Stopping sequoiadb_containers_data1_1   ... done
Stopping sequoiadb_containers_catalog_1 ... done
Stopping sequoiadb_containers_data3_1   ... done


$ sudo docker-compose ps
           Name                         Command                State     Ports
------------------------------------------------------------------------------
sequoiadb_containers_catalog_1   sh -c chmod +x /startup.sh ...   Exit 137        
sequoiadb_containers_coord_1     sh -c chmod +x /startup.sh ...   Exit 137        
sequoiadb_containers_data1_1     sh -c chmod +x /startup.sh ...   Exit 137        
sequoiadb_containers_data2_1     sh -c chmod +x /startup.sh ...   Exit 137        
sequoiadb_containers_data3_1     sh -c chmod +x /startup.sh ...   Exit 137        
sequoiadb_containers_mysql_1     sh -c chmod +x /startup.sh ...   Exit 137  

```
#### 4.1.2 Start 
```
$ sudo docker-compose start
Starting catalog ... done
Starting data1   ... done
Starting data2   ... done
Starting data3   ... done
Starting coord   ... done
Starting mysql   ... done


$ sudo docker-compose ps
           Name                         Command               State           Ports         
--------------------------------------------------------------------------------------------
sequoiadb_containers_catalog_1   sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_coord_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data1_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data2_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data3_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_mysql_1     sh -c chmod +x /startup.sh ...   Up      0.0.0.0:3310->3310/tcp

# Verity mysql client is up
$ sudo docker-compose logs mysql
Attaching to sequoiadb_containers_mysql_1
mysql_1    | Starting service sequoiasql-mysql ...
mysql_1    | ok. (PID: 38)
...
mysql_1    | MySql instance is started
```



### 4.2 Down/Up Cluster
#### 4.2.1 Down
The `down` command will stop and remove the containers, networks deployed for the sequoiadb cluster.   
:warning: NOTE that `down` command should be executed with caution since there is no rollback/recovery when containers are destroyed.   

```
$ sudo docker-compose down
Stopping sequoiadb_containers_mysql_1   ... done
Stopping sequoiadb_containers_coord_1   ... done
Stopping sequoiadb_containers_data2_1   ... done
Stopping sequoiadb_containers_data1_1   ... done
Stopping sequoiadb_containers_catalog_1 ... done
Stopping sequoiadb_containers_data3_1   ... done
Removing sequoiadb_containers_mysql_1   ... done
Removing sequoiadb_containers_coord_1   ... done
Removing sequoiadb_containers_data2_1   ... done
Removing sequoiadb_containers_data1_1   ... done
Removing sequoiadb_containers_catalog_1 ... done
Removing sequoiadb_containers_data3_1   ... done
Removing network sequoiadb_containers_sequoiadb_net

$ sudo docker-compose ps
Name   Command   State   Ports
------------------------------
```

#### 4.2.2 Up
The `up` command will create and start the services (containers, networks) defined for sequoiadb cluser.
```
$ sudo docker-compose up -d 
Creating network "sequoiadb_containers_sequoiadb_net" with the default driver
Creating sequoiadb_containers_data2_1   ... done
Creating sequoiadb_containers_data3_1   ... done
Creating sequoiadb_containers_catalog_1 ... done
Creating sequoiadb_containers_data1_1   ... done
Creating sequoiadb_containers_coord_1   ... done
Creating sequoiadb_containers_mysql_1   ... done

$ sudo docker-compose ps
           Name                         Command               State           Ports         
--------------------------------------------------------------------------------------------
sequoiadb_containers_catalog_1   sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_coord_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data1_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data2_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_data3_1     sh -c chmod +x /startup.sh ...   Up                            
sequoiadb_containers_mysql_1     sh -c chmod +x /startup.sh ...   Up      0.0.0.0:3310->3310/tcp

# Verify MySQL connection
$ mysql -h 127.0.0.1  -P 3310 -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.25 Source distribution

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show storage engines;
+--------------------+---------+----------------------------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                                          | Transactions | XA   | Savepoints |
+--------------------+---------+----------------------------------------------------------------------------------+--------------+------+------------+
| SequoiaDB          | DEFAULT | SequoiaDB storage engine(Community). Plugin: eebcb4f, Driver: 3.2.3, BuildTime:  | YES          | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                                            | NO           | NO   | NO         |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                                               | NO           | NO   | NO         |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears)                   | NO           | NO   | NO         |
| MyISAM             | YES     | MyISAM storage engine                                                            | NO           | NO   | NO         |
| CSV                | YES     | CSV storage engine                                                               | NO           | NO   | NO         |
| ARCHIVE            | YES     | Archive storage engine                                                           | NO           | NO   | NO         |
| InnoDB             | YES     | Supports transactions, row-level locking, and foreign keys                       | YES          | YES  | YES        |
| FEDERATED          | NO      | Federated MySQL storage engine                                                   | NULL         | NULL | NULL       |
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables                        | NO           | NO   | NO         |
+--------------------+---------+----------------------------------------------------------------------------------+--------------+------+------------+

```

## 5.0 Remarks / 结论 
The cluster is only used for testing purposes and should not be used directly in a production environment.
该集群仅为测试使用，不可直接应用于生产环境。

