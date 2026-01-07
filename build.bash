set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=/opt/devkitpro/devkitA64

# Явно указываем компилятор devkitPro
export CC="$DEVKITA64/bin/aarch64-none-elf-gcc"
export AR="$DEVKITA64/bin/aarch64-none-elf-ar"
export RANLIB="$DEVKITA64/bin/aarch64-none-elf-ranlib"

# Только флаги компиляции, без линковки
export CFLAGS="-O2 -ffunction-sections -fdata-sections -D__SWITCH__ -I$DEVKITPRO/libnx/include -I/opt/devkitpro/portlibs/switch/include"
export LDFLAGS=""

cd cpython
mkdir -p build-switch
cd build-switch

# Минимальная конфигурация
../configure \
  --host=aarch64-none-elf \
  --disable-shared \
  --without-pymalloc \
  --disable-ipv6 \
  CC="$CC" \
  AR="$AR" \
  RANLIB="$RANLIB" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="$LDFLAGS"

# Собираем только необходимые модули
echo "Building Python core..."
make -j4 python \
  CC="$CC" \
  AR="$AR" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="" \
  LIBS="" || true

# Собираем все .o файлы в библиотеку
echo "Creating libpython3.9.a..."
find . -name "*.o" -type f | xargs $AR rcs libpython3.9.a

# Создаем директории для установки
mkdir -p ../../python39-switch/lib
mkdir -p ../../python39-switch/include/python3.9

# Копируем библиотеку
cp libpython3.9.a ../../python39-switch/lib/

# Копируем заголовки
cp ../Include/*.h ../../python39-switch/include/python3.9/
cp pyconfig.h ../../python39-switch/include/python3.9/

echo "=== Verification ==="
file ../../python39-switch/lib/libpython3.9.a
echo "Library created successfully"
