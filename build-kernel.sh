#!/bin/bash

# docs: https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel

# output of "uname -r"
kernelVersionToBuild=6.8.0-55-generic
kernelSourceVersion=i$( echo $kernelVersionToBuild | cut -d\- -f 1)

# install kernel sources
sudo apt build-dep linux linux-image-unsigned-$kernelVersionToBuild

# install required packages to build the ubuntu kernel
sudo apt install libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm

# install kernel sources


cd $kernelSourceVersion

time make ARCH=x86 mrproper

# import ubuntu kernel config
time ./debian/scripts/misc/annotations --arch amd64 --flavour generic --import ../config-$kernelVersionToBuild

# apply config
time fakeroot debian/rules clean updateconfigs

# build the: quicker build
time fakeroot debian/rules binary-headers binary-generic binary-perarch

