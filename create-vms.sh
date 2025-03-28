#/bin/bash

export LABREPO=/home/admin/lab

echo "---"
echo "Provision lab virtual machines"
echo "---"
sudo qemu-img create -f qcow2 /imagemode/image-mode-test.qcow2 1G
sudo qemu-img create -f qcow2 /imagemode/image-mode.qcow2 1G

#---------------------------------------------------------
#!!!!!!!!!!!!!! Overwrite default network !!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!! Current configuration will be LOST !!!!!!!
sudo virsh net-destroy default
sudo virsh net-undefine default
sudo virsh net-create $LABREPO/net-default.xml
#----------------------------------------------------------
sudo virsh destroy imagemode
sudo virsh undefine imagemode
sudo virsh create $LABREPO/vm-imagemode.xml
sudo virsh destroy image-mode-test
sudo virsh undefine image-mode-test
sudo virsh create $LABREPO/vm-imagemodetest.xml
