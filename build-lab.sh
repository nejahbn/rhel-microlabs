#/bin/bash

export SEEDHOST="192.168.50.71"
export SEEDUSER="admin"
export LABREPO=/home/admin/lab

sudo dnf install -y curl openssh-clients
sudo dnf install -y ansible-core

# create admin user locally
echo "creating 'admin' user locally"
sudo adduser admin
sudo usermod -aG wheel admin

# set admin password
echo "setting password for the admin user"
sudo passwd admin

#download  lab artifacts to  LABREPO

echo "Downloading lab artifacts from the seed host"
echo "Please provide the passwprd of the SEEDUSER on SEEDHOST"
scp -r $SEEDUSER@$SEEDHOST:lab/ $LABREPO
sudo chown -R admin:admin $LABREPO
gunzip $LABREPO/image-mode.qcow2.gz

echo "Run ansible playbooks"
echo "Please provide the credentials of the local 'admin' user"
ansible-playbook -kK -i hosts configure-laptops.yml

echo "Provision lab virtual machines"
sudo qemu-img create -f qcow2 /imagemode/image-mode-test.qcow2 1G
sudo qemu-img create -f qcow2 /imagemode/image-mode.qcow2 1G

#---------------------------------------------------------
#!!!!!!!!!!!!!! Overwrite default network !!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!! Current configuration will be LOST !!!!!!!
sudo virsh net-undefine default
sudo virsh create $LABREPO/net-default.xml
#----------------------------------------------------------
sudo virsh create $LABREPO/vm-imagemode.xml
sudo virsh create $LABREPO/vm-imagemodetest.xml





