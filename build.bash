#!/bin/bash
set -e

cd cpython

# Используем целевой Python для компиляции байт-кода после сборки
echo "Configuring CPython for Switch..."
./configure --host=aarch64-none-elf --build=x86_64-linux-gnu \
    --disable-ipv6 --prefix=$(pwd)/../python39-switch \
    --enable-optimizations

echo "Building CPython..."
make -j$(nproc)

echo "Installing CPython to local directory..."
make install

cd ..

# Копируем необходимые библиотеки
echo "Copying libraries..."
mkdir -p python39-switch/lib
cp cpython/libpython3.9.a python39-switch/lib/

echo "Creating directory structure on SD card..."
mkdir -p python39-switch/sd_layout/python
mkdir -p python39-switch/sd_layout/python/lib
mkdir -p python39-switch/sd_layout/python/userlib

# Копируем стандартную библиотеку Python
echo "Copying Python standard library..."
cp -r python39-switch/lib/python3.9/* python39-switch/sd_layout/python/lib/

# Компилируем байт-код с помощью только что собранного Python
echo "Compiling Python bytecode for Switch..."
# Временно переключаемся на использование cross-компилятора для компиляции .pyc
# Этот шаг можно пропустить, если возникают проблемы
# python39-switch/bin/python3.9 -OO -m compileall python39-switch/sd_layout/python/lib/ -q

echo "Build complete!"
echo "To run on Switch:"
echo "1. Copy everything from 'python39-switch/sd_layout/' to root of your SD card"
echo "2. Copy 'switch/python_switch.nro' to 'switch/python_switch.nro' on SD card"
echo "3. Run via Homebrew Launcher"
