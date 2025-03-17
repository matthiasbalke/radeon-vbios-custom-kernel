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
sudo sh -c 'echo "deb http://azure.archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb-src http://azure.archive.ubuntu.com/ubuntu noble main restricted universe multiverse

deb http://azure.archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb-src http://azure.archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse" > /etc/apt/sources.list.d/official-source-package-repositories.list'

# refresh repositories
time sudo apt-get update

# install kernel source packages
time sudo apt-get build-dep -y linux linux-image-unsigned-$kernelVersionToBuild

# install required packages to build the ubuntu kernel
time sudo apt-get install -y libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm

# get kernel sources
time apt source linux-image-unsigned-$kernelVersionToBuild

pwd
ls -al

# create directory for custom kernel packages
mkdir ubuntu-custom-kernel-packages

cd linux-$kernelSourceVersion

# apply patches
patch -p1 < ../0001-change-debian.master-release-version.patch
patch -p1 < ../0002-patch-to-read-vBIOS-from-disk.patch

chmod a+x debian/rules
chmod a+x debian/scripts/*
chmod a+x debian/scripts/misc/*

echo "Build started at:"
date
echo ""

time make mrproper

# import ubuntu kernel config
time ./debian/scripts/misc/annotations --arch amd64 --flavour generic --import ../config-$kernelVersionToBuild

# apply config
# even if this does not exit with exit 0, continue
time fakeroot debian/rules clean updateconfigs || true

# build the: quicker build
time fakeroot debian/rules binary-headers binary-generic

