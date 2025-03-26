#/bin/bash

export SEEDHOST="localhost"
export SEEDUSER="roo"
export LABREPO=/home/admin/lab

sudo dnf install -y curl openssh-clients
sudo dnf install -y ansible-core
sudo ansible-galaxy collection install ansible.posix

# create admin user locally
echo "---"
echo "creating 'admin' user locally"
echo "and setting password for the admin user"
echo "---"
sudo adduser admin
sudo usermod -aG wheel admin

# set admin password
sudo passwd admin

#download  lab artifacts to  LABREPO
echo "---"
echo "Downloading lab artifacts from the seed host"
echo "Please provide the passwprd of the SEEDUSER on SEEDHOST"
echo "---"
sudo scp -r $SEEDUSER@$SEEDHOST:lab/ $LABREPO
sudo chown -R admin:admin $LABREPO

echo "---"
echo "Uncompress Imagemode VM image template..."
echo "---"

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


sudo firewall-cmd --permanent --add-service={nfs,rpc-bind,mountd}
sudo firewall-cmd --permanent --add-port={5555/tcp,5555/udp,6666/tcp,6666/udp}
sudo firewall-cmd --reload





