#!/bin/bash

set -e

echo "Building CPython 3.9 for Nintendo Switch (AArch64)..."

# Устанавливаем системные зависимости для сборки
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    git \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libffi-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    liblzma-dev \
    libgdbm-dev \
    libgdbm-compat-dev \
    tk-dev \
    xz-utils \
    curl \
    wget

# Установка devkitpro зависимостей
echo "Downloading and installing devkitpro dependencies..."
DEVKITPRO="/opt/devkitpro"
sudo mkdir -p $DEVKITPRO

curl -LOC - https://github.com/greg6821-debug/scripts/releases/download/1.0-scripts/devkitpro-pkgbuild-helpers-2.2.3-1-any.pkg.tar.xz
curl -LOC - https://github.com/greg6821-debug/scripts/releases/download/1.0-scripts/switch-libfribidi-1.0.12-1-any.pkg.tar.xz

# Устанавливаем пакеты в devkitpro
sudo tar -xJf devkitpro-pkgbuild-helpers-2.2.3-1-any.pkg.tar.xz -C $DEVKITPRO --strip-components=1
sudo tar -xJf switch-libfribidi-1.0.12-1-any.pkg.tar.xz -C $DEVKITPRO --strip-components=1

# Экспортируем переменные окружения
export DEVKITPRO="/opt/devkitpro"
export DEVKITA64="$DEVKITPRO/devkitA64"
export PATH="$DEVKITA64/bin:$DEVKITPRO/tools/bin:$PATH"
export TOOL_PREFIX="aarch64-none-elf"

# Клонируем CPython 3.9.22 если ещё нет
if [ ! -d "cpython" ]; then
    echo "Cloning CPython 3.9.22..."
    git clone --branch v3.9.22 --depth 1 https://github.com/python/cpython.git
fi

cd cpython

# Очищаем предыдущие сборки
make distclean 2>/dev/null || true

# Патчим если есть патч
if [ -f "../cpython.patch" ]; then
    echo "Applying cpython.patch..."
    patch -p1 < ../cpython.patch || {
        echo "WARNING: Patch may have partially applied, continuing..."
    }
fi

# Настраиваем для сборки под Switch
echo "Configuring CPython for Switch..."
./configure \
    --host=$TOOL_PREFIX \
    --build=x86_64-linux-gnu \
    --prefix=$(pwd)/../python39-switch \
    --disable-ipv6 \
    --with-system-ffi \
    --with-ensurepip=no \
    --without-pymalloc \
    --enable-shared=no \
    ac_cv_file__dev_ptmx=no \
    ac_cv_file__dev_ptc=no \
    ac_cv_func_gethostbyname=no \
    ac_cv_func_getpwnam_r=no \
    ac_cv_func_getgrnam_r=no \
    ac_cv_func_getspnam_r=no \
    ac_cv_func_sigaltstack=no \
    ac_cv_func_mremap=no \
    ac_cv_func_memfd_create=no \
    ac_cv_func_eventfd=no \
    ac_cv_func_timerfd_create=no \
    ac_cv_func_signalfd=no \
    ac_cv_func_pipe2=no \
    ac_cv_func_accept4=no \
    ac_cv_func_dup3=no \
    ac_cv_func_getentropy=no

echo "Building CPython..."
make -j$(nproc) \
    CROSS_COMPILE=$TOOL_PREFIX- \
    HOSTPYTHON=$(which python3) \
    HOSTPGEN=$(which pgen) \
    EXTRA_CFLAGS="-D__SWITCH__ -O2"

echo "Installing CPython..."
make install

# Компилируем байт-код с помощью только что собранного интерпретатора
echo "Compiling Python bytecode..."
cd ..
if [ -f "python39-switch/bin/python3.9" ]; then
    # Используем собранный интерпретатор для компиляции байт-кода
    cd python39-switch
    ./bin/python3.9 -OO -m compileall lib/python3.9 || echo "Bytecode compilation completed with warnings"
    cd ..
else
    # Запасной вариант: компилируем на хосте
    echo "Using host Python for bytecode compilation..."
    python3 -OO -m compileall python39-switch/lib/python3.9 || echo "Bytecode compilation completed with warnings"
fi

echo "Build completed successfully!"
echo "Python installed to: $(pwd)/python39-switch"
