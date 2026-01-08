#!/usr/bin/env bash
set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITA64/bin:$PATH

echo "[*] Building CPython for aarch64-none-elf"

CPYTHON_DIR=$(pwd)/cpython
PATCH_FILE=$(pwd)/../cpython.patch
SETUP_LOCAL_FILE=$(pwd)/../cpython_config_files/Setup.local

cd "$CPYTHON_DIR"

# применяем патч
if [ -f "$PATCH_FILE" ]; then
    echo "[*] Applying patch $PATCH_FILE"
    patch -p1 < "$PATCH_FILE"
fi

# Setup.local
export PYTHON_SETUP_LOCAL=$(realpath "$SETUP_LOCAL_FILE")

# Экспорт переменных для кросс-компиляции прямо в окружении
export ac_cv_file__dev_ptmx=yes
export ac_cv_file__dev_null=yes
export ac_cv_file__dev_zero=yes
export ac_cv_file__dev_random=yes
export ac_cv_func_getentropy=no
export ac_cv_func_getrandom=no
export ac_cv_func_getpagesize=yes

# Запуск configure
./configure \
  --host=aarch64-none-elf \
  --build=x86_64-linux-gnu \
  --disable-shared \
  --without-ensurepip \
  --enable-ipv6=no \
  --prefix=/python

# Сборка
make -j$(nproc)

echo "[*] Build finished successfully"
