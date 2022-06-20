# geth client docker compose

## 依赖服务

influxdb 1.8

grafana 8.5

## influxdb

创建 `geth` 数据库

## 安装 geth node

### 修改 `.env`

```sh
# geth docker 镜像
ETHEREUM_CLIENT_GO_IMAGE=ethereum/client-go:v1.10.17
# influxdb 地址
METRICS_INFLUXDB_ENDPOINT=http://127.0.0.1:8086
# influxdb tags
METRICS_INFLUXDB_TAGS="host=geth-node"
# influxdb 用户名
METRICS_INFLUXDB_USERNAME=geth
# influxdb 密码
METRICS_INFLUXDB_PASSWORD=123456
```

### 修改创建块 json 数据

`geth_config/genesis.custom.json`

### 修改自定义 geth config

 `geth_config/config.custom.toml`

```ini
[Eth]
NetworkId = 101010
SyncMode = "full"

[Node]
HTTPHost = "0.0.0.0"
HTTPModules = ["eth", "net", "web3", "txpool"]

[Node.P2P]
# 本安装服务默认不开启自动发现功能，需要手动修改连接的 geth nodes 地址
StaticNodes = []
```

### 添加导入的备份数据

在 `geth_backups` 目录中放置导出的历史备份压缩包，启动时会自动导入

### 执行安装geth client

```sh
./install_geth.sh
```

## 导入 grafana  geth 图表

访问 grafana ui, 手动导入图表 `grafana_dashboards/single-geth-dashboard_rev1.json`
