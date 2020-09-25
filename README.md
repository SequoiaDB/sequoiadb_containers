# SequoiaDB - 基于Docker容器的cluster部署教程
为了方便快速的用户体验，SequoiaDB提供基于Docker的cluster部署。   
本页介绍如何在Docker环境中部署SequoiaDB分布式集群。

# 快速启动
您可以使用Ubuntu平台上的默认配置快速启动sequoiadb分布式集群部署，如下所示:


#### 环境设置:
1. 安装Docker引擎
```
  sudo apt-get install -y docker.io 
```   

2. 安装Docker-Compose
```
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```   

3. 安装MySQL客户端（如果尚未安装)
```
  sudo apt install mysql-client-core-5.7 
```   


#### 已下载
有选项来下载所需的软件包。
###### 备选案文1。 克隆此回购
```
  git clone git@github.com:SequoiaDB/sequoiadb_containers.git
```

##### 选项2：手动下载以下文件（保留相同的目录结构)
```
docker-compose.yaml
scripts/startup.sh
scripts/coord_startup.sh
scripts/mysql_startup.sh
```

#### 部署赛车集群
```
  cd sequoiadb_containers  （或者到docker-compose的目录。yaml文件下载)
  sudo docker-compose up -d
```

#### 验证部署
```
  sudo docker-compose ps
  sudo docker-compose logs coord
  sudo docker-compose logs mysql
```

#### 连接到mysql实例
```shell
$ mysql -h 127.0.0.1 -P 3310 -u root
```
继续 [3.2验证MySQL连接](README_DETAILS.md#32-验证mysql连接).   

#### 备注
群集仅用于测试目的，不应在生产环境中直接使用。


## 有关群集部署和群集管理的更多详细信息 [点击这里](README_DETAILS.md).
