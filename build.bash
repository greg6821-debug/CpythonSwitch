#!/bin/bash

set -e  # Выход при ошибке

echo "=== Building CPython 3.9 for Nintendo Switch ==="

# Настройка путей
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CPYTHON_DIR="$TOP_DIR/cpython"
BUILD_DIR="$TOP_DIR/build"
INSTALL_DIR="$TOP_DIR/python39-switch"
SDMC_DIR="$TOP_DIR/sdmc"

# Создаем директории
mkdir -p "$BUILD_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$SDMC_DIR/python"

# Проверяем наличие исходников CPython
if [ ! -d "$CPYTHON_DIR" ]; then
    echo "Error: CPython source not found at $CPYTHON_DIR"
    echo "Please run setup.bash first"
    exit 1
fi

cd "$BUILD_DIR"

echo "Configuring CPython for Switch (AArch64)..."

# Конфигурация для Switch
"$CPYTHON_DIR/configure" \
    --host=aarch64-none-elf \
    --build=x86_64-pc-linux-gnu \
    --prefix="$INSTALL_DIR" \
    --disable-shared \
    --enable-optimizations \
    --with-system-ffi \
    --with-ensurepip=no \
    --without-readline \
    --enable-ipv6 \
    ac_cv_file__dev_ptmx=no \
    ac_cv_file__dev_ptc=no \
    ac_cv_have_long_long_format=yes

echo "Building CPython..."

# Компилируем только нужные компоненты
make -j$(nproc) python python.bin libpython3.9.a

echo "Installing CPython to $INSTALL_DIR..."

# Устанавливаем минимальный набор
make install DESTDIR="" prefix="$INSTALL_DIR"

# Создаем структуру для SD-карты
echo "Preparing SD card structure..."
cp -r "$INSTALL_DIR/lib/python3.9" "$SDMC_DIR/python/lib"
cp -r "$INSTALL_DIR/include" "$SDMC_DIR/python/include"

# Компилируем байт-код Python для целевой архитектуры
echo "Compiling Python bytecode for AArch64..."
# Используем хост-интерпретатор с явным указанием версии
cd "$INSTALL_DIR"
python3.9 -m compileall -f -q lib/python3.9

# Копируем скомпилированный байт-код на SD-карту
cp -r lib/python3.9/__pycache__ "$SDMC_DIR/python/lib/python3.9/" 2>/dev/null || true

# Создаем пример main.py для SD-карты
cat > "$SDMC_DIR/python/main.py" << 'EOF'
print("=" * 50)
print("Python 3.9 on Nintendo Switch")
print("=" * 50)
print(f"Platform: {__import__('sys').platform}")
print(f"Version: {__import__('sys').version}")
print(f"Path: {__import__('sys').path}")
print()

# Простой тест
try:
    import math
    print(f"Math module loaded: pi = {math.pi:.5f}")
except Exception as e:
    print(f"Error loading math: {e}")

print()
print("Ready for interactive mode...")
EOF

echo "=== Build complete! ==="
echo "Installation directory: $INSTALL_DIR"
echo "SD card structure: $SDMC_DIR"
echo ""
echo "To deploy to Switch:"
echo "1. Copy contents of '$SDMC_DIR' to root of your SD card"
echo "2. Copy the compiled NRO to /switch/ on your SD card"
echo "3. Run from Homebrew Menu"
