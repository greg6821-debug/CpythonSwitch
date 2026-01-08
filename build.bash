#!/usr/bin/env bash
set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITA64/bin:$PATH

echo "[*] Building CPython from git checkout"

cd cpython

./configure \
  --host=aarch64-none-elf \
  --build=x86_64-linux-gnu \
  --disable-shared \
  --without-ensurepip \
  --enable-ipv6=no \
  --prefix=/python

make -j$(nproc)
