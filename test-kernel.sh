#!/bin/bash


# create ramdisk
#mkinitramfs -o ramdisk.img

qemu-system-x86_64 \
-kernel vmlinuz-6.8.0-55-generic \
-hda ubuntu-24.04.2-live-server-amd64.iso \
-append "console=ttyS0" \
-initrd ramdisk.img \
-nographic \
-m 512 \

# redirect port 22 to host port 5555
#-device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22 \

# exit using ctrl + a, c, q

