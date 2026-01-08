#!/usr/bin/env bash
set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITA64/bin:$PATH

echo "[*] Building Switch homebrew (.nro)"

cd switch_app

make clean
make

mkdir -p ../python39-switch
cp *.nro ../python39-switch/
