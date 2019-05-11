# 架构设计

## 微服务
服务间使用grpc进行通讯，protobuf定义见：
[proto](https://github.com/pjoc-team/pay-proto)

## 支付调用时序图
```plantuml
skinparam monochrome true

actor User
participant "Channel" as E
participant "PayCenter(Biz)" as A
box "Internal Service"
participant "PayGateway" as B
participant "CallbackGateway" as F
participant "PayChannels" as G
participant "NotifyGateway" as H
participant "PayDatabase" as C
database "MySQL" as D
control "Queue" AS I
end box

User -> A: Page
activate A

A -> B: Create Order
activate B
B -> B: Verify
B -> B: Generate Order

B -> C: Save Order
activate C
C -> D: SQL
activate D
D -> C: OK
deactivate D
C -> B: OK
deactivate C

B -> G: Order Request
activate G
G -> E: Order Request
G -> B: Response Data
deactivate G

B -> A: Response
deactivate B

A -> User: Show QrCode or redirect url
deactivate A

...

User -> E: Pay
E --> F: Notify
activate F
F -> G: Notify
activate G
G -> G: Verify
G -> F: OK
deactivate G
F -> C: Update
activate C
C -> D: SQL
activate D
D -> C: OK
deactivate D
C -> F: OK
deactivate C
F -> H: Process result
activate H
H -> I: push
H -> F: OK
deactivate H
F --> E: OK
E -> A: Redirect Url
A -> User: Show PayResult Page


loop
    activate H
    H -> I: pull
    H --> A: Notify
    alt notify success
      A --> H: OK
      H -> C: Update notify status
      C -> H: OK
    else notify failed
      loop 10 times
        H --> A: Notify
      end
    end
    deactivate H
end
```


## 整体部署架构
```plantuml format="svg"
' define
cloud Kubernetes{
  package Core {
    node PayGateway
    node QueryGateway
    node RefundGateway
    node TransferGateway
    node CallbackGateway
    node NotifyGateway
    node PayDatabase
  }

  package Channels {
    node Channel...
    node ChannelWechat
    node ChannelAlipay
  }

  node PayManagerSystem
  node OrderMonitor
  node PayCenter

}

database mysql

'cloud EtcdCloud{
'  storage etcd1
'  storage etcd2
'  storage etcd3
'}

' === relations ===
'PayCenter ..> EtcdCloud
'PayGateway ..> EtcdCloud
'QueryGateway ..> EtcdCloud
'RefundGateway ..> EtcdCloud
'TransferGateway ..> EtcdCloud
'PayDatabase ..> EtcdCloud
'ChannelWechat ..> EtcdCloud
'ChannelAlipay ..> EtcdCloud
'Channel... ..> EtcdCloud

PayCenter -> PayGateway

PayGateway ---> PayDatabase
PayGateway ...> Channels

QueryGateway ---> PayDatabase
QueryGateway ...> Channels

RefundGateway ---> PayDatabase
RefundGateway ...> Channels

CallbackGateway ---> PayDatabase
CallbackGateway ...> Channels
CallbackGateway -> NotifyGateway


TransferGateway ---> PayDatabase
TransferGateway ...> Channels

PayManagerSystem -> PayDatabase
PayManagerSystem -> QueryGateway

OrderMonitor ---> PayDatabase
OrderMonitor -> QueryGateway

PayDatabase ---> mysql

```

# 交互
## 配置
核心交易系统是将配置信息存储在`etcd`容器内
### 渠道
- 基础目录: `/pub/pjoc/pay/config`
- 每个渠道占用一个文件夹，每个渠道账户占用一个`文件`，例如微信存放在`/pub/pjoc/pay/config/wechat`目录下，appId: 2088123456 所在的配置信息存储在`/pub/pjoc/pay/config/wechat/2088123456`
