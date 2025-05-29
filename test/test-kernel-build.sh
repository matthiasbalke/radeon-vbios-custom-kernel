#!/bin/bash

# cleaup build dir
rmdir ubuntu-custom-kernel-packages || true

# copy all patches
rm ./*.patch || true
cp -a ../00*.patch ./

# copy all config files
rm ./config-* || true
cp -a ../config-* ./


rm -rf linux-6.8.0 || true
../install-kernel-sources.sh

../build-kernel.sh
