#!/usr/bin/env bash
set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITA64/bin:$PATH

echo "[*] Building CPython for aarch64-none-elf"

# Путь к исходникам и патчу
CPYTHON_DIR=$(pwd)/cpython
PATCH_FILE=$(pwd)/../cpython.patch
CONFIG_SITE_FILE=$(pwd)/../cpython_config_files/config.site
SETUP_LOCAL_FILE=$(pwd)/../cpython_config_files/Setup.local

cd "$CPYTHON_DIR"

# Применяем патч
if [ -f "$PATCH_FILE" ]; then
    echo "[*] Applying patch $PATCH_FILE"
    patch -p1 < "$PATCH_FILE"
fi

# Подключаем config.site
export CONFIG_SITE="$CONFIG_SITE_FILE"

# Подключаем Setup.local
export PYTHON_SETUP_LOCAL="$SETUP_LOCAL_FILE"

# Запускаем configure для кросс-компиляции
./configure \
  --host=aarch64-none-elf \
  --build=x86_64-linux-gnu \
  --disable-shared \
  --without-ensurepip \
  --enable-ipv6=no \
  --prefix=/python

# Собираем
make -j$(nproc)

echo "[*] Build finished successfully"
