# docker-composes

## 环境依赖

RockyLinux 8.5

docker-ce

docker-compose-plugin

## docker 安装

### 卸载 docker 旧版本

```
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

### 安装 docker yum repo

```
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

### 安装 docker engine

```
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### 设置开机启动 docker 并且现在就启动 

```
sudo systemctl enable docker --now
```