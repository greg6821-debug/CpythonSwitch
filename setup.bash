#!/bin/bash

set -e

echo "Setting up CPython 3.9 build environment for Switch..."

# Устанавливаем системные зависимости
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
    python3 \
    python3-pip \
    python3-venv \
    wget \
    curl \
    xz-utils \
    unzip

# Установка devkitpro
echo "Setting up devkitpro..."
if [ ! -d "/opt/devkitpro" ]; then
    echo "Installing devkitpro from official installer..."
    wget -q https://github.com/devkitPro/pacman/releases/download/v1.0.2/devkitpro-pacman.amd64.deb
    sudo dpkg -i devkitpro-pacman.amd64.deb
    sudo rm -f devkitpro-pacman.amd64.deb
    
    # Инициализируем пакетный менеджер
    sudo dkp-pacman -Syu --noconfirm
    sudo dkp-pacman -S --noconfirm \
        switch-dev \
        devkitA64 \
        libnx \
        switch-tools \
        switch-pkg-config \
        switch-examples
fi

# Создаем виртуальное окружение для Python инструментов
echo "Setting up Python virtual environment..."
python3 -m venv switch-build-venv
source switch-build-venv/bin/activate

# Устанавливаем необходимые Python пакеты
echo "Installing Python build dependencies..."
pip install --upgrade pip setuptools wheel
pip install Cython==0.29.37
pip install distribute future six

# Клонируем CPython если нет
if [ ! -d "cpython" ]; then
    echo "Cloning CPython repository..."
    git clone --branch v3.9.22 --depth 1 https://github.com/python/cpython.git
fi

# Применяем патчи если есть
if [ -f "cpython.patch" ]; then
    echo "Checking cpython.patch..."
    cd cpython
    if patch --dry-run -p1 < ../cpython.patch 2>/dev/null; then
        echo "Applying cpython.patch..."
        patch -p1 < ../cpython.patch
        echo "Patch applied successfully"
    else
        echo "Patch may have already been applied or has conflicts"
    fi
    cd ..
fi

# Настраиваем переменные окружения
echo "Setting up environment variables..."
export DEVKITPRO="/opt/devkitpro"
export DEVKITA64="$DEVKITPRO/devkitA64"
export PATH="$DEVKITA64/bin:$DEVKITPRO/tools/bin:$PATH"

# Проверяем инструменты
echo "Checking toolchain..."
which aarch64-none-elf-gcc || echo "WARNING: aarch64-none-elf-gcc not found"
which pkg-config || echo "WARNING: pkg-config not found"

echo "========================================"
echo "Setup completed successfully!"
echo "Environment variables:"
echo "  DEVKITPRO: $DEVKITPRO"
echo "  DEVKITA64: $DEVKITA64"
echo ""
echo "To activate Python environment:"
echo "  source switch-build-venv/bin/activate"
echo ""
echo "To build CPython:"
echo "  ./build.bash"
echo ""
echo "To build Switch application:"
echo "  cd switch && make"
echo "========================================"
