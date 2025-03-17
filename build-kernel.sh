#!/bin/bash -x

# exit after first error
set -e

# docs: https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel

# output of "uname -r"
kernelVersionToBuild=6.8.0-55-generic
kernelSourceVersion=$( echo $kernelVersionToBuild | cut -d\- -f 1)

# CI debugging
uname -r
uname -a

# add deb-src sources
sudo sh -c 'echo "deb-src http://de.archive.ubuntu.com/ubuntu noble main restricted universe⁄ndeb-src http://de.archive.ubuntu.com/ubuntu noble-updates main restricted universe" > /etc/apt/sources.list.d/official-source-package-repositories.list'

# refresh repositories
time sudo apt-get update

# install kernel sources
time sudo apt-get install build-dep linux linux-image-unsigned-$kernelVersionToBuild

# install required packages to build the ubuntu kernel
time sudo apt-get install libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm

ls -al

cd linux-$kernelSourceVersion

time make ARCH=x86 mrproper

# import ubuntu kernel config
time ./debian/scripts/misc/annotations --arch amd64 --flavour generic --import ../config-$kernelVersionToBuild

# apply config
time fakeroot debian/rules clean updateconfigs

# build the: quicker build
time fakeroot debian/rules binary-headers binary-generic binary-perarch

