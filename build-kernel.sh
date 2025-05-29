#!/bin/bash -x

# exit after first error
set -e

# docs: https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel

# output of "uname -r"
kernelVersionToBuild=6.8.0-60-generic
kernelSourceVersion=$( echo $kernelVersionToBuild | cut -d\- -f 1)

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

exit 3

# apply config
# even if this does not exit with exit 0, continue
time fakeroot debian/rules clean updateconfigs || true

# build the: quicker build
time fakeroot debian/rules binary-headers binary-generic

