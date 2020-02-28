# SequoiaDB - 基于Docker容器的cluser部署教程

为了方便快速的用户体验，SequoiaDB提供基于Docker的cluseter部署。   
本页介绍如何在Docker环境中部署SequoiaDB分布式集群。


# 1.0 群集配置

我们将在六个容器中部署一个多节点，高度可用的SequoiaDB集群，如下所示:


| 主机名 | IP | 分区组 | 软件版本 |
| --- | --- |  --- | --- |
| Coord | [IP 由泊坞窗分配]:11810 | SYSCoord | SequoiaDB 3.2.3 |
| Catalog | [IP 由泊坞窗分配]:11800 | SYSCatalogGroup | SequoiaDB 3.2.3 |
| Data1 | [IP 由泊坞窗分配]:11820 | group1 | SequoiaDB 3.2.3 |
| Data2 | [IP 由泊坞窗分配]:11820 | group1 | SequoiaDB 3.2.3 |
| Data3 | [IP 由泊坞窗分配]:11820 | group1 | SequoiaDB 3.2.3 |
| Data1 | [IP 由泊坞窗分配]:11830 | group2 | SequoiaDB 3.2.3 |
| Data2 | [IP 由泊坞窗分配]:11830 | group2 | SequoiaDB 3.2.3 |
| Data3 | [IP 由泊坞窗分配]:11830 | group2 | SequoiaDB 3.2.3 |
| Data1 | [IP 由泊坞窗分配]:11840 | group3 | SequoiaDB 3.2.3 |
| Data2 | [IP 由泊坞窗分配]:11840 | group3 | SequoiaDB 3.2.3 |
| Data3 | [IP 由泊坞窗分配]:11840 | group3 | SequoiaDB 3.2.3 |
| MySQL instance | [IP 由泊坞窗分配]:3310 | - | SequoiaSQL-MySQL 3.2.3 |   
   
该集群包括一个协调器节点、一个目录节点、三个数据组，每个数据组有三个副本数据节点和一个MySQL实例节点。   


## 2.0 环境

*OS :*  Ubuntu 18   
*Docker Version :* 18.09.7  
*Docker Compose Version:* 1.25.3   
*Database Version :* SequoiaDB 3.2.3   
*MySql Client:* Sequoiasql-mysql
*Cluster Deployment :* 1 coordinator, 1 catalog, 3 data nodes, and 1 MySQL instance   
   
## 2.1 Docker安装   
#### 2.1.1 Docker
对于在不同平台上的Docker安装，请参阅Docker安装指南[Docker安装](https://docs.docker.com/install/).
```
  sudo apt-get install -y docker.io
```

#### 2.1.2 Docker-compose
Docker compose是一个用于定义和部署在YAML文件中定义的多容器泊坞应用程序的工具(i.e: [docker-compose.yaml](/docker-compose.yaml)).   
可以找到不同平台的安装说明[这里](https://docs.docker.com/compose/install/).

```
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

#### 2.1.3 MySql客户端
安装MySQL客户端（如果尚未安装)   
```
  sudo apt install mysql-client-core-5.7 
```

## 3.0 SequoiaDB分布式集群部署
定义了Sequoiadb集群配置 "sequoiadb_containers/docker-compose.yaml".

有两个选项可以下载所需的软件包。   
##### 选项1：克隆此回购
```
  git clone http://git.sequoiadb.com/mayuran.sub/sequoiadb_containers.git
```

##### 选项2：手动下载以下文件（保留相同的目录结构)
```
docker-compose.yaml
scripts/startup.sh
scripts/coord_startup.sh
scripts/mysql_startup.sh
```

### 3.1 部署 sequoiadb 集群
`docker-compose up` 命令将:   
    - 如果没有在本地找到，请从docker hup下载图像。   
    - 创建所需的容器。   
    - 启动容器。   
    - 初始化sequoiadb集群和mysql实例。   
1. 部署集群
```
  cd sequoiadb_containers  （或者到docker-compose的目录。yaml文件下载)
  sudo docker-compose up -d
```

2. 检查群集的状态
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

3. 等待集群被部署和mysql连接到协调器节点。 可以按如下方式检查集群状态。
 
```
# 检查 coordinator 日志
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


# 检查mysql日志
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

### 3.2 验证MySQL连接

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

验证SequoiaDB配置:   
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

### 3.3 测试

用户可以使用MySQL命令创建数据库和表：
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


## 4.0 集群管理
### 4.1 Stop/Start cluster
使用`up`命令创建sequoiadb集群后，它可以停止并按如下方式启动。    
请注意，"stop"命令不会删除容器，因此不会丢失任何数据。   


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
`down` 命令将停止并删除sequoiadb集群部署的容器。   
:warning: NOTE 这个`down`命令应该谨慎执行，因为当容器被破坏时没有回滚/恢复。   

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
`up`命令将创建并启动为sequoiadb cluser定义的服务（容器，网络）。
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

# 验证MySQL连接
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

## 5.0 备注 
群集仅用于测试目的，不应在生产环境中直接使用。   

