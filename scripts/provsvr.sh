#!/bin/bash

apt-get update -y
apt-get install git -y
apt-get install software-properties-common -y
apt-add-repository ppa:ansible/ansible -y
apt-get update -y
apt-get install ansible -y

mkdir /etc/ansible/conf
ansible-pull -d /etc/ansible/init -U https://github.com/ianalderman/holansiblepull.git