#!/bin/bash
set -e

echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y build-essential git zip unzip

echo "Setting up Python environment..."
python3 -m pip install --user virtualenv
python3 -m venv venv
source venv/bin/activate

pip install distribute future six setuptools wheel

echo "Cloning CPython 3.9..."
git clone --depth 1 --branch v3.9.22 https://github.com/python/cpython.git

echo "Applying patch..."
if ! patch -p1 -d cpython < cpython.patch; then
    echo "ERROR: Failed to apply cpython.patch"
    echo "Make sure the patch file exists and is compatible with CPython 3.9.22"
    exit 1
fi

echo "Setup complete!"
echo "Run './build.bash' to build CPython for Switch"
