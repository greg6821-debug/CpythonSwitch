#!/bin/bash
set -e

echo "=== Setting up Python 3.9 build environment ==="

# Установка системных зависимостей[citation:1]
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    liblzma-dev \
    pkg-config

# Скачивание и распаковка CPython
if [ ! -d "CPython-3.9.22" ]; then
    wget https://www.python.org/ftp/python/3.9.22/Python-3.9.22.tar.xz
    tar -xf Python-3.9.22.tar.xz
    mv Python-3.9.22 CPython-3.9.22
fi

# Применение патча с проверкой
cd CPython-3.9.22
if [ -f "../cpython.patch" ]; then
    echo "Applying cpython.patch..."
    if ! patch -p1 -N < ../cpython.patch; then
        echo "Warning: Patch may have failed or already applied"
    fi
fi

# ИСПРАВЛЕНИЕ: Установка Cython 0.29.37[citation:3]
echo "Installing Cython 0.29.37..."
pip3 install Cython==0.29.37 --no-binary :all:

echo "=== Setup completed successfully ==="
