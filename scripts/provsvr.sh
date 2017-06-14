#!/bin/bash

sudo apt-get update -y
sudo apt-get install git -y
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y

sudo mkdir /etc/ansible/conf
sudo ansible-pull -d /etc/ansible/init -U https://github.com/ianalderman/holansiblepull.git