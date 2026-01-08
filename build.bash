#!/usr/bin/env bash
set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITA64/bin:$PATH

export CC=aarch64-none-elf-gcc
export AR=aarch64-none-elf-ar
export RANLIB=aarch64-none-elf-ranlib

export CFLAGS="-O2 -ffunction-sections -fdata-sections"
export LDFLAGS=""

PYTHON_VERSION=3.9.22

tar xf Python-$PYTHON_VERSION.tar.xz
cd Python-$PYTHON_VERSION

patch -p1 < ../cpython.patch
cp ../cpython_config_files/config.site .

./configure \
    --host=aarch64-none-elf \
    --build=x86_64-linux-gnu \
    --disable-shared \
    --enable-ipv6=no \
    --without-ensurepip \
    --prefix=/python

make -j$(nproc)
