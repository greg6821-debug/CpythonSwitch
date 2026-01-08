#!/bin/bash
set -e

echo "=== Building Python 3.9 for Nintendo Switch ==="

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=/opt/devkitpro/devkitA64
export PATH=$DEVKITPRO/tools/bin:$PATH

cd CPython-3.9.22

# Конфигурация для AArch64 (Switch)
./configure \
    --host=aarch64-none-elf \
    --build=$(./config.guess) \
    --disable-ipv6 \
    --without-ensurepip \
    --with-system-ffi \
    --enable-optimizations \
    ac_cv_file__dev_ptmx=no \
    ac_cv_file__dev_ptc=no \
    ac_cv_have_long_long_format=yes

# Сборка
make -j$(nproc) python

# КРИТИЧЕСКОЕ ИСПРАВЛЕНИЕ: Компиляция байт-кода с помощью ЦЕЛЕВОГО интерпретатора
echo "Compiling Python bytecode with target interpreter..."
./python -OO -m compileall lib/

# Копирование результата
cd ..
mkdir -p python39-switch
cp -r CPython-3.9.22/build/lib.*/ python39-switch/
cp CPython-3.9.22/python python39-switch/

echo "=== Build completed successfully ==="
