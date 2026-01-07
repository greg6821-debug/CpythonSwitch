set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=/opt/devkitpro/devkitA64

# Явно указываем компилятор devkitPro
export CC="$DEVKITA64/bin/aarch64-none-elf-gcc"
export CXX="$DEVKITA64/bin/aarch64-none-elf-g++"
export AR="$DEVKITA64/bin/aarch64-none-elf-ar"
export RANLIB="$DEVKITA64/bin/aarch64-none-elf-ranlib"

# Флаги для сборки под Switch (только для компиляции, без линковки)
export CFLAGS="-O2 -ffunction-sections -fdata-sections -D__SWITCH__ -I$DEVKITPRO/libnx/include"
export CPPFLAGS="$CFLAGS"
export LDFLAGS=""

source $DEVKITPRO/switchvars.sh
pushd cpython
mkdir build-switch
cp ../cpython_config_files/config.site build-switch
pushd build-switch
mkdir local_prefix
export LOCAL_PREFIX=$(realpath local_prefix)

# Конфигурация для кросс-компиляции
../configure \
  --host=aarch64-none-elf \
  --build=$(../config.guess) \
  --prefix="$LOCAL_PREFIX" \
  --disable-ipv6 \
  --disable-shared \
  --without-pymalloc \
  --without-ensurepip \
  --with-system-ffi=no \
  --with-threads=no \
  --disable-profiling \
  --disable-universal-archs \
  CC="$CC" \
  AR="$AR" \
  RANLIB="$RANLIB" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="$LDFLAGS" \
  CONFIG_SITE="config.site"
popd
cp ../cpython_config_files/Setup.local build-switch/Modules
pushd build-switch

# 1. Собираем только объектные файлы для библиотеки Python
echo "=== Building Python object files ==="
make -j $(getconf _NPROCESSORS_ONLN) \
  CC="$CC" \
  AR="$AR" \
  RANLIB="$RANLIB" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="" \
  python

# 2. Создаем статическую библиотеку вручную из собранных .o файлов
echo "=== Creating static library ==="
find . -name "*.o" -type f | xargs $AR rcs libpython3.9.a

# Проверяем архитектуру
echo "=== Checking library architecture ==="
file libpython3.9.a
$aR --info libpython3.9.a | head -20

# 3. Устанавливаем библиотеку
mkdir -p $LOCAL_PREFIX/lib
cp libpython3.9.a $LOCAL_PREFIX/lib/libpython3.9.a

# 4. Устанавливаем заголовки
echo "=== Installing headers ==="
find ../Include -name "*.h" -exec install -D {} $LOCAL_PREFIX/include/python3.9/{} \;
find . -name "pyconfig.h" -exec install -D {} $LOCAL_PREFIX/include/python3.9/ \;

popd
popd

mkdir -p ./python39-switch
mv $LOCAL_PREFIX/* ./python39-switch/

# Оптимизация Python файлов
pushd python39-switch/lib/python3.9
rm -r test 2>/dev/null || true
rm -r lib2to3/tests 2>/dev/null || true
rm subprocess.py 2>/dev/null || true
cp ../../../stub/subprocess.py ./ 2>/dev/null || true
find . -type l -not -name \*.py -delete 2>/dev/null || true
find . -type d -empty -delete 2>/dev/null || true
# Не компилируем .py файлы, так как нет Python на хосте
popd

echo "=== Final library check ==="
file python39-switch/lib/libpython3.9.a
echo "=== Build complete ==="
