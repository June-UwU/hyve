#!/bin/bash

HYPERVISOR_PATH=""
PLATFORM=""
while [[ $# -gt 0 ]]; do
  OPTION="$1"

  case $OPTION in
    --hypervisor-path)
        HYPERVISOR_PATH="$2"
        shift 2
        ;;
    --platform)
        PLATFORM="$2"
        shift 2
        ;;
    *) # unknown option
        echo "unknown option: $1"
        exit 1
        ;;
  esac
done

HYPERVISOR_ARG=""

if [ -z "$PLATFORM"]; then
    echo "no platform for provided, please provide a platform using the option --platform <platform>"
    exit 1
fi

if [ ! -z "$HYPERVISOR_PATH" ]; then
    HYPERVISOR_ARG="BL32="$(realpath "$HYPERVISOR_PATH")""
    echo "using hypervisor from : $HYPERVISOR_ARG"
fi

source ./goto-git-root.sh

HYPERVISOR_BIN=$(find ./bin -type f -name "hyve")
BINARY_PATH=$(find . -type f -name "fip.bin")

if [ ! -z "$HYPERVISOR_BIN" ]; then
    HYPERVISOR_CRC="$(cksum "$(realpath "$HYPERVISOR_PATH")")"
    BINARY_BIN="$(cksum "$(realpath "$BINARY_PATH")")"
    if [ "$HYPERVISOR_CRC" = "$BINARY_BIN" ]; then
        echo "recompiling hypervisor"
        cd arm-trusted-firmware
        make PLAT=$PLATFORM $HYPERVISOR_ARG CROSS_COMPILE=aarch64-linux-gnu- ARM_ARCH_MINOR=4 all fip -j8
    fi
else
    echo "no hyve executable found, recompiling TF-A"
    cd arm-trusted-firmware
    make PLAT=$PLATFORM $HYPERVISOR_ARG CROSS_COMPILE=aarch64-linux-gnu- ARM_ARCH_MINOR=4 all fip -j8
fi

mkdir -p ../bin
cp $(find . -type f -name "fip.bin") ../bin/hyve