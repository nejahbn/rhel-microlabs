#/bin/bash

export SEEDHOST="192.168.50.71"
export SEEDUSER="admin"
export LABREPO=/home/admin/lab

sudo dnf install -y curl openssh-clients
sudo dnf install -y ansible-core

# create admin user locally
echo "---"
echo "creating 'admin' user locally"
echo "---"
sudo adduser admin
sudo usermod -aG wheel admin

# set admin password
echo "---"
echo "setting password for the admin user"
echo "---"
sudo passwd admin

#download  lab artifacts to  LABREPO
echo "---"
echo "Downloading lab artifacts from the seed host"
echo "Please provide the passwprd of the SEEDUSER on SEEDHOST"
echo "---"
sudo scp -r $SEEDUSER@$SEEDHOST:lab/ $LABREPO
sudo chown -R admin:admin $LABREPO
sudo gunzip $LABREPO/image-mode.qcow2.gz

echo "---"
echo "Run ansible playbooks"
echo "Please provide the credentials of the local 'admin' user"
echo "---"
ansible-playbook -kK -i hosts configure-laptops.yml

echo "---"
echo "Provision lab virtual machines"
echo "---"
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





