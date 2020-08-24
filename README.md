## k8s安装脚本
此脚本提供快速部署`k8s`集群，采用`ansible-playbook`实现简单配置自动化部署.
### 功能
- **集群策略** 单Master部署、多Master部署
- **集群版本** 版本: `v1.15`、`v1.16`、`v1.17`、`v1.18`
- **部署环境** CentOS7、`不支持公有云环境`
### 配置
1. **单Master**
`修改inventory文件`
```
[all]
# 所有需要安装k8s的机器
master1 ansible_host=192.168.51.21 ansible_port=22 ansible_ssh_pass=123456
node1 ansible_host=192.168.51.22 ansible_port=22 ansible_ssh_pass=123456
node2 ansible_host=192.168.51.23 ansible_port=22 ansible_ssh_pass=123456
node3 ansible_host=192.168.51.24 ansible_port=22 ansible_ssh_pass=123456

[k8smaster]
# 单Master策略此处为一台机器
master1

[k8snode]
# 需要加入到集群的工作节点
node[1:3]

[all:vars]
version=1.17.5  # k8s版本
interfacename=eth0  # 集群网段网卡名称
# externalip=1.1.1.1  # 外部网络ip授权访问apiserver地址

[etcd]
# 单节点etcd存储
master1
```
2. **多Master**
`修改inventory文件`
```
[all]
# 所有需要安装k8s的机器
master1 ansible_host=192.168.51.21 ansible_port=22 ansible_ssh_pass=123456
master2 ansible_host=192.168.51.22 ansible_port=22 ansible_ssh_pass=123456
master3 ansible_host=192.168.51.23 ansible_port=22 ansible_ssh_pass=123456
node3 ansible_host=192.168.51.24 ansible_port=22 ansible_ssh_pass=123456

[k8smaster]
# 多Master策略此处为多台机器
master[1:3]

[k8snode]
# 需要加入到集群的工作节点
node1

[all:vars]
vip=192.168.51.20  # 虚拟ip地址
version=1.17.5  # k8s版本
interfacename=eth0  # 集群网段网卡名称
# externalip=1.1.1.1  # 外部网络ip授权访问apiserver地址

[etcd]
# 多节点etcd存储
master[1:3]
```

### 安装
> 确保所有机器都存在`interfacename`参数填写的网卡名称并且符合对应网段
```
./install.sh
```
