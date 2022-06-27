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

## 健康检查命令

查询连接的 peers , 正常同 `geth_config/config.custom.toml` 中 `StaticNodes` 配置的数量，如果数量减少表示连接peer有异常，需要告警处理

```sh
docker exec -it geth-geth-1 geth attach /root/.ethereum/geth.ipc --exec admin.peers.length

# 输出结果
3
```

查询 当前块高度, 正常情况下2s 出一个块，（`geth_config/genesis.custom.json`中设置的 `period`配置为`2s` ）

如果当前块高度 - 5分钟前块高度 < 100  表示块同步缓慢，需要告警处理

```sh
docker exec -it geth-geth-1 geth attach /root/.ethereum/geth.ipc --exec eth.blockNumber

# 输出结果
1943754
```

查个队列状态，pending > 16 或 queued > 16, 就有可能有问题了，需要排查处理

```sh
docker exec -it geth-geth-1 geth attach /root/.ethereum/geth.ipc --exec txpool.status

# 输出结果
{
  pending: 0,
  queued: 0
}
```

