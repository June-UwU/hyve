#!/bin/bash

# List your desired packages here
packages=("aarch64-linux-gnu-gcc" "aarch64-linux-gnu-linux-api-headers" "git" "ninja" "cmake" "aarch64-linux-gnu-gdb" "qemu-full")

# Join packages into a single string
pkg_list="${packages[@]}"

# Detect and install using the appropriate package manager
if command -v apt-get >/dev/null 2>&1; then
    echo "Detected apt (Debian/Ubuntu)"
    sudo apt-get update
    sudo apt-get install -y $pkg_list

elif command -v dnf >/dev/null 2>&1; then
    echo "Detected dnf (Fedora/RHEL)"
    sudo dnf install -y $pkg_list

elif command -v yum >/dev/null 2>&1; then
    echo "Detected yum (older RHEL/CentOS)"
    sudo yum install -y $pkg_list

elif command -v pacman >/dev/null 2>&1; then
    echo "Detected pacman (Arch)"
    sudo pacman -Sy --noconfirm $pkg_list

elif command -v zypper >/dev/null 2>&1; then
    echo "Detected zypper (openSUSE)"
    sudo zypper install -y $pkg_list

elif command -v apk >/dev/null 2>&1; then
    echo "Detected apk (Alpine)"
    sudo apk add --no-cache $pkg_list

else
    echo "❌ No known package manager found. Cannot install packages."
    exit 1
fi
