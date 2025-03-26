#/bin/bash

export SEEDHOST="192.168.50.71"
export SEEDUSER="admin"

sudo dnf install -y curl openssh-clients
sudo dnf install -y ansible-core

# create admin user locally
sudo adduser admin
sudo usermod -aG wheel admin

# set admin password
sudo passwd admin

#download the imagemode VM template image to /tmp/image-mode.qcow2
scp $SEEDUSER@$SEEDHOST:microlab/image-mode.qcow2.gz /tmp
gunzip /tmp/image-mode.qcow2.gz

ansible-playbook -kK -i hosts configure-laptops