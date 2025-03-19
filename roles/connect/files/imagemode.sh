#!/bin/bash

/usr/bin/virsh start image-mode-test
/usr/bin/virt-viewer --connect qemu:///system image-mode-test