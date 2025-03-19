#!/bin/bash

/usr/bin/sudo /usr/bin/virsh destroy imagemode
/usr/bin/logger -p local4.info -t "User: "${USER} "Destroying imagemode vm - "$?
/usr/bin/sudo /usr/bin/virsh destroy image-mode-test
/usr/bin/logger -p local4.info -t "User: "${USER} "Destroying image-mode-test vm - "$?
/usr/bin/sudo /usr/bin/virsh destroy podman
/usr/bin/logger -p local4.info -t "User: "${USER} "Destroying podman vm - "$?
/usr/bin/sudo /usr/bin/virsh destroy openscap
/usr/bin/logger -p local4.info -t "User: "${USER} "Destroying openscap vm - "$?

case "${USER}" in

	"imagemode")
	/usr/bin/sudo /usr/bin/qemu-img convert -f qcow2 -O qcow2 -o lazy_refcounts=on /var/lib/libvirt/images/templates/image-mode.qcow2 /imagemode/image-mode.qcow2
	/usr/bin/logger -p local4.info -t "User: "${USER} "Restoring image-mode vm - "$?
	/usr/bin/sudo /usr/bin/qemu-img convert -f qcow2 -O qcow2 -o lazy_refcounts=on /var/lib/libvirt/images/templates/image-mode-test.qcow2 /imagemode/image-mode-test.qcow2
	/usr/bin/logger -p local4.info -t "User: "${USER} "Restoring image-mode-test vm - "$?
	/usr/bin/sudo /usr/bin/virsh start imagemode
	/usr/bin/logger -p local4.info -t "User: "${USER}"Starting imagemode vm - "$?
	/usr/bin/sudo /usr/bin/chmod 0664 /imagemode/image-mode-test.qcow2
	;;

	"openscap")
	/usr/bin/sudo /usr/bin/qemu-img convert -f qcow2 -O qcow2 -o lazy_refcounts=on /var/lib/libvirt/images/templates/openscap.qcow2 /var/lib/libvirt/images/openscap.qcow2
	/usr/bin/logger -p local4.info -t "User: "${USER} "Restoring openscap vm - "$?
	/usr/bin/sudo /usr/bin/virsh start openscap
	/usr/bin/logger -p local4.info -t "User: "${USER}"Starting openscap vm - "$?
	;;

	"podman")
	/usr/bin/sudo /usr/bin/qemu-img convert -f qcow2 -O qcow2 -o lazy_refcounts=on /var/lib/libvirt/images/templates/podman.qcow2 /var/lib/libvirt/images/podman.qcow2
	/usr/bin/logger -p local4.info -t "User: "${USER} "Restoring podman vm - "$?
	/usr/bin/sudo /usr/bin/virsh start podman
	/usr/bin/logger -p local4.info -t "User: "${USER}"Starting podman vm - "$?
	;;

esac