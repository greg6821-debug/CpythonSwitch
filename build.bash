#!/usr/bin/env bash
set -e

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITA64/bin:$PATH

echo "[*] Building CPython for aarch64-none-elf"

CPYTHON_DIR=$(pwd)/cpython
PATCH_FILE=$(pwd)/../cpython.patch

cd "$CPYTHON_DIR"

# 1. Применяем патч
if [ -f "$PATCH_FILE" ]; then
    echo "[*] Applying patch $PATCH_FILE"
    patch -p1 < "$PATCH_FILE"
fi

# Setup.local
#export PYTHON_SETUP_LOCAL=$(pwd)/cpython_config_files/Setup.local

# Экспорт переменных для кросс-компиляции прямо в окружении
export ac_cv_file__dev_ptmx=no
export ac_cv_file__dev_ptc=no
export ac_cv_lib_dl_dlopen=no

export ac_cv_func_statvfs=no
export ac_cv_header_sys_resource_h=no
export ac_cv_func_fork=no
export ac_cv_func_execve=no
export ac_cv_func_waitpid=no
export ac_cv_func_pipe=no
export ac_cv_func_kill=no

export ac_cv_func_mmap=no
export ac_cv_func_sigaction=no
export ac_cv_have_long_long=yes

# 3. Конфигурируем
./configure \
  --host=aarch64-none-elf \
  --build=x86_64-linux-gnu \
  --disable-shared \
  --without-ensurepip \
  --enable-ipv6=no \
  --prefix=/python

# 4. Собираем
make -j$(nproc)

echo "[*] Build finished successfully"
