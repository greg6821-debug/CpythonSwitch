#!/bin/bash

set -e  # Выход при ошибке

echo "=== Setting up CPython 3.9 build environment ==="

# Настройка путей
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CPYTHON_DIR="$TOP_DIR/cpython"

# Проверка наличия devkitPro
if [ -z "$DEVKITPRO" ]; then
    echo "Error: DEVKITPRO environment variable not set!"
    echo "Please install devkitPro first: https://devkitpro.org"
    exit 1
fi

export PATH="$DEVKITPRO/devkitA64/bin:$PATH"
export PATH="$DEVKITPRO/tools/bin:$PATH"

# Установка необходимых пакетов
echo "Installing required packages..."
sudo dkp-pacman -Syu --noconfirm \
    switch-dev \
    switch-portlibs \
    devkitA64 \
    aarch64-none-elf-binutils \
    aarch64-none-elf-gcc \
    aarch64-none-elf-newlib \
    python3

# Клонирование CPython 3.9, если еще не существует
if [ ! -d "$CPYTHON_DIR" ]; then
    echo "Cloning CPython 3.9.22..."
    git clone --depth 1 --branch v3.9.22 https://github.com/python/cpython.git "$CPYTHON_DIR"
else
    echo "CPython directory already exists, updating..."
    cd "$CPYTHON_DIR"
    git fetch origin v3.9.22
    git checkout v3.9.22
fi

# Применение патчей, если есть
cd "$CPYTHON_DIR"

if [ -f "$TOP_DIR/cpython.patch" ]; then
    echo "Applying cpython.patch..."
    if ! patch -p1 < "$TOP_DIR/cpython.patch"; then
        echo "Warning: Failed to apply cpython.patch"
        echo "Continuing without patch..."
    fi
fi

# Настройка переменных окружения для кросс-компиляции
export CC="aarch64-none-elf-gcc"
export CXX="aarch64-none-elf-g++"
export AR="aarch64-none-elf-ar"
export RANLIB="aarch64-none-elf-ranlib"
export STRIP="aarch64-none-elf-strip"

export CFLAGS="-O2 -march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE -I$DEVKITPRO/libnx/include -I$DEVKITPRO/portlibs/switch/include -D__SWITCH__"
export LDFLAGS="-specs=$DEVKITPRO/libnx/switch.specs -march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE -L$DEVKITPRO/libnx/lib -L$DEVKITPRO/portlibs/switch/lib"

echo "=== Environment setup complete ==="
echo "Next steps:"
echo "1. Run ./build.bash to build CPython"
echo "2. Navigate to switch/ directory and run 'make'"
echo "3. Copy files to your Switch SD card"
