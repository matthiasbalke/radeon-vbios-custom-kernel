#!/bin/bash

rmdir ubuntu-custom-kernel-packages || true

../build-kernel.sh
