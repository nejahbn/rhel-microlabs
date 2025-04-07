#/bin/bash

export SEEDHOST="10.202.100.60"
export SEEDUSER="roo"
export LABREPO=/home/admin/lab

sudo dnf install -y curl openssh-clients
sudo dnf install -y ansible-core
sudo dnf install -y firewalld

sudo systemctl enable --now firewalld

#sudo ansible-galaxy collection install ansible.posix

# create admin user locally
echo "---"
echo "creating 'admin' user locally"
echo "and setting password for the admin user"
echo "---"
sudo adduser admin
sudo usermod -aG wheel admin

# set admin password
sudo passwd admin

sudo mkdir $LABREPO
sudo chown -R admin:admin $LABREPO

#download  lab artifacts to  LABREPO
echo "---"
echo "Downloading lab artifacts from the seed host"
echo "Please provide the passwprd of the SEEDUSER on SEEDHOST"
echo "---"
sudo scp -r $SEEDUSER@$SEEDHOST:lab/ $LABREPO
sudo chown -R admin:admin $LABREPO

echo "---"
echo "Uncompress imagemode VM disk template..."
echo "---"

sudo gunzip $LABREPO/image-mode.qcow2.gz

sudo firewall-cmd --permanent --add-service={nfs,rpc-bind,mountd}
sudo firewall-cmd --permanent --add-port={5555/tcp,5555/udp,6666/tcp,6666/udp}
sudo firewall-cmd --reload

echo "---"
echo "Run ansible playbooks"
echo "Please provide the credentials of the local 'admin' user"
echo "---"
ansible-playbook -kK -i hosts configure-laptops.yml













