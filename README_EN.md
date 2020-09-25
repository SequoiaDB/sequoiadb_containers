# SequoiaDB - Docker container based cluser deployment tutorial

To facilitate a quick user experience, SequoiaDB provides Docker-based cluseter deployment.   
This page describes how to deploy SequoiaDB distributed cluster in Docker environment.

# Quick Start
You can quick start sequoiadb distributed cluster deployment with default configuration on Ubuntu platform as follows:
#### Environment Setup:
1. Install Docker engine
```
  sudo apt-get install -y docker.io 
```   

2. Install Docker-Compose
```
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```   

3. Install MySQL client (if it's not already installed)
```
  sudo apt install mysql-client-core-5.7 
```   


#### Download
There are to options to download the required package.
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

#### Deploy sequoiadb cluster
```
  cd sequoiadb_containers  (or to the directory where docker-compose.yaml file is downloaded)
  sudo docker-compose up -d
```

#### Verify deployment
```
  sudo docker-compose ps
  sudo docker-compose logs coord
  sudo docker-compose logs mysql
```

#### Connect to mysql instance
```shell
$ mysql -h 127.0.0.1 -P 3310 -u root
```
Continue to [3.2 Verify MySQL Connection](README_DETAILS_EN.md#32-verify-mysql-connection).   

#### Remarks / 结论
The cluster is only used for testing purposes and should not be used directly in a production environment.
该集群仅为测试使用，不可直接应用于生产环境。
   

## For more details on cluster deployment and cluster management [click here](README_DETAILS_EN.md).
