#!/bin/bash -x

# exit after first error
set -e

# docs: https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel

# output of "uname -r"
kernelVersionToBuild=6.8.0-55-generic
kernelSourceVersion=i$( echo $kernelVersionToBuild | cut -d\- -f 1)

# CI debugging
uname -r
uname -a

# add deb-src sources
sudo sh -c 'echo "deb-src http://ftp.hosteurope.de/mirror/archive.ubuntu.com noble main restricted universe multiverse⁄ndeb-src http://ftp.hosteurope.de/mirror/archive.ubuntu.com noble-updates main restricted universe multiverse" > /etc/apt/sources.list.d/official-source-package-repositories.list'

# refresh repositories
time sudo apt update

# install kernel sources
time sudo apt build-dep linux linux-image-unsigned-$kernelVersionToBuild

# install required packages to build the ubuntu kernel
time sudo apt install libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm

ls -al

cd $kernelSourceVersion

time make ARCH=x86 mrproper

# import ubuntu kernel config
time ./debian/scripts/misc/annotations --arch amd64 --flavour generic --import ../config-$kernelVersionToBuild

# apply config
time fakeroot debian/rules clean updateconfigs

# build the: quicker build
time fakeroot debian/rules binary-headers binary-generic binary-perarch

