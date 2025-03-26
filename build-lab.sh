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

#download the imagemode VM template image to /tmp/lab/image-mode.qcow2
scp -r $SEEDUSER@$SEEDHOST:lab/ /tmp/
gunzip /tmp/lab/image-mode.qcow2.gz

ansible-playbook -kK -i hosts configure-laptops.yml

sudo qemu-img create -f qcow2 /imagemode/image-mode-test.qcow2 1G
sudo qemu-img create -f qcow2 /imagemode/image-mode.qcow2 1G

#---------------------------------------------------------
#!!!!!!!!!!!!!! Overwrite default network !!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!! Current configuration will be LOST !!!!!!!
sudo virsh net-undefine default
sudo virsh create /tmp/lab/net-default.xml
#----------------------------------------------------------
sudo virsh create /tmp/lab/vm-imagemode.xml
sudo virsh create /tmp/lab/vm-imagemodetest.xml




