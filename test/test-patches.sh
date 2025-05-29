#!/bin/bash

cd test-patches
cp ../linux-6.8.0/debian.master/changelog debian.master/changelog
patch -p1 -ui ../../0001-change-debian.master-release-version.patch

cp ../linux-6.8.0/drivers/gpu/drm/radeon/radeon_bios.c drivers/gpu/drm/radeon/radeon_bios.c
patch -p1 -ui ../../0002-patch-to-read-vBIOS-from-disk.patch
