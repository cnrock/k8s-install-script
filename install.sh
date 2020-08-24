#!/bin/bash

function init() {

yum install -y epel-release
yum install -y ansible
sed -i 's/#host_key_checking/host_key_checking/' /etc/ansible/ansible.cfg

check=$(ansible all -m ping)
sub='UNREACHABLE'

if [[ "$check" == *"$sub"* ]] ; then
  echo '目的主机不可达'
  echo '停止执行'
  exit
fi

}

function install() {
  init
  ansible-playbook main.yml -f 10 -i inventory
}

function reset() {
  init
  ansible-playbook reset.yml -f 10 -i inventory
}

function join() {
  init
  ansible-playbook join.yml -f 10 -i inventory -e exist_node=$(kubectl get node | awk 'NR>1 { print $1 }' | paste -s -d ",")
}

function menu() {
title="K8s Installer"
time=`date +%Y-%m-%d`
clear
cat <<EOF
##################################################
                  `echo -e "\033[34m$title\033[0m"`
##################################################
*   1) `echo -e "\033[32m安装\033[0m"`
*   2) `echo -e "\033[30m重置\033[0m"`
*   3) `echo -e "\033[34m添加节点\033[0m"`
*   4) `echo -e "\033[31m退出\033[0m"`
##################################################
                   `echo -e "\033[32m$time\033[0m"`
##################################################
EOF
}

menu
while true
do
  read -p "请输入选项: " option
  echo $option

  case $option in
    1)
        install
        exit
          ;;
    2)
        reset
        exit
          ;;
    3)
        join
        exit
          ;;
    4)
        echo -e "\033[37;46m退出成功!\033[0m"
        break
          ;;
  esac
done