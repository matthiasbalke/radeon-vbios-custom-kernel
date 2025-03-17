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
sudo sh -c 'echo "deb http://ftp.hosteurope.de/mirror/archive.ubuntu.com noble main restricted universe multiverse
deb-src http://ftp.hosteurope.de/mirror/archive.ubuntu.com noble main restricted universe multiverse

deb http://ftp.hosteurope.de/mirror/archive.ubuntu.com noble-updates main restricted universe multiverse
deb-src http://ftp.hosteurope.de/mirror/archive.ubuntu.com noble-updates main restricted universe multiverse" > /etc/apt/sources.list.d/official-source-package-repositories.list'

# refresh repositories
time sudo apt-get update

pwd

# install kernel source packages
time sudo apt-get build-dep -y linux linux-image-unsigned-$kernelVersionToBuild

pwd
ls -al

# install required packages to build the ubuntu kernel
time sudo apt-get install -y libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm

# get kernel sources
time apt source linux-image-unsigned-$kernelVersionToBuild

pwd
ls -al

cd linux-$kernelSourceVersion

pwd

time make ARCH=x86 mrproper

# import ubuntu kernel config
time ./debian/scripts/misc/annotations --arch amd64 --flavour generic --import ../config-$kernelVersionToBuild

# apply config
time fakeroot debian/rules clean updateconfigs

# build the: quicker build
time fakeroot debian/rules binary-headers binary-generic binary-perarch

