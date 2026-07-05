#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "$WORKSPACE_DIR"

apt update
apt install -y git cmake build-essential python3-pip python3-setuptools python3-wheel

cd "$WORKSPACE_DIR/src/unitree_sdk2"
mkdir -p build
cd build
cmake ..
make -j"$(nproc)"
make install
ldconfig

cd "$WORKSPACE_DIR/src"

if [ ! -d unitree_sdk2_python ]; then
  git clone https://github.com/unitreerobotics/unitree_sdk2_python.git
fi

cd unitree_sdk2_python
pip3 install -e .

python3 -c "import unitree_sdk2py; print('unitree_sdk2py OK')"