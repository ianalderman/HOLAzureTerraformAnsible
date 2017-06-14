  variable server_role {}
  variable subnet_id {}
  variable vm_size {}
  variable publisher {}
  variable offer {}
  variable sku {}
  variable version {}
  variable computer_name {}
  variable admin_username {}
  variable admin_password {}
  variable StudentId {}
  variable azure_region {}

variable custom_data {
    type = "string"
    default = <<EOF
#!/bin/bash

sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y

sudo mkdir /etc/ansible/conf
sudo ansible-pull -d /etc/ansible/init -U https://github.com/ianalderman/holansiblepull.git
EOF
}