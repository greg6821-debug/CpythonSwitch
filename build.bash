set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=/opt/devkitpro/devkitA64

# Явно указываем компилятор devkitPro
export CC="$DEVKITA64/bin/aarch64-none-elf-gcc"
export CXX="$DEVKITA64/bin/aarch64-none-elf-g++"
export AR="$DEVKITA64/bin/aarch64-none-elf-ar"
export RANLIB="$DEVKITA64/bin/aarch64-none-elf-ranlib"

# Флаги для сборки под Switch
export CFLAGS="-O2 -ffunction-sections -fdata-sections -D__SWITCH__ -I$DEVKITPRO/libnx/include"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-specs=$DEVKITPRO/libnx/switch.specs"

source $DEVKITPRO/switchvars.sh
pushd cpython
mkdir build-switch
cp ../cpython_config_files/config.site build-switch
pushd build-switch
mkdir local_prefix
export LOCAL_PREFIX=$(realpath local_prefix)

# Явно передаем компилятор в configure
../configure \
  --host=aarch64-none-elf \
  --build=$(../config.guess) \
  --prefix="$LOCAL_PREFIX" \
  --disable-ipv6 \
  --disable-shared \
  --without-pymalloc \
  CC="$CC" \
  AR="$AR" \
  RANLIB="$RANLIB" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="$LDFLAGS" \
  CONFIG_SITE="config.site"
popd
cp ../cpython_config_files/Setup.local build-switch/Modules
pushd build-switch

# Собираем только библиотеку Python
make -j $(getconf _NPROCESSORS_ONLN) libpython3.9.a

# Проверяем архитектуру
echo "Проверяем архитектуру библиотеки:"
file libpython3.9.a
aarch64-none-elf-objdump -f libpython3.9.a | head -5

mkdir -p $LOCAL_PREFIX/lib
cp libpython3.9.a $LOCAL_PREFIX/lib/libpython3.9.a
make libinstall
make inclinstall
popd
popd

mkdir -p ./python39-switch
mv $LOCAL_PREFIX/* ./python39-switch/

pushd python39-switch/lib/python3.9
rm -r test
rm -r lib2to3/tests
rm subprocess.py
cp ../../../stub/subprocess.py ./
find . -type l -not -name \*.py -delete
find . -type d -empty -delete
find . -name \*.py -exec python3 -OO -m py_compile {} \;
popd

echo "=== Проверяем финальную библиотеку ==="
file python39-switch/lib/libpython3.9.a
