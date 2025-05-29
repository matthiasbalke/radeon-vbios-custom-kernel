#!/bin/bash -x

# exit after first error
set -e

# docs: https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel

# output of "uname -r"
kernelVersionToBuild=6.8.0-60-generic
kernelSourceVersion=$( echo $kernelVersionToBuild | cut -d\- -f 1)

# get kernel sources
time apt source linux-image-unsigned-$kernelVersionToBuild
