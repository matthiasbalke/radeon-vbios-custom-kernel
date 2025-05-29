#!/bin/bash -x

# exit after first error
set -e

# docs: https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel

# output of "uname -r"
kernelVersionToBuild=6.8.0-60-generic
kernelSourceVersion=$( echo $kernelVersionToBuild | cut -d\- -f 1)

# apply config
# even if this does not exit with exit 0, continue
time fakeroot debian/rules clean updateconfigs || true

# build the: quicker build
time fakeroot debian/rules binary-headers binary-generic

