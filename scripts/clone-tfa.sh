#!/bin/bash
source ./goto-git-root.sh

if [ -d "./arm-trusted-firmware" ]; then
    echo "trusted firmware exists"
else
    echo "cloning trusted firmware for arm"
    git clone -b master --single-branch https://github.com/ARM-software/arm-trusted-firmware.git --depth 1
fi

