#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

MUJOCO_VERSION="3.2.7"
SIMULATE_DIR="$WORKSPACE_DIR/src/unitree_mujoco/simulate"
MUJOCO_DIR="$SIMULATE_DIR/mujoco"

cd "$WORKSPACE_DIR"

apt update
apt install -y wget unzip cmake build-essential libglfw3-dev libglew-dev \
  libyaml-cpp-dev libeigen3-dev libboost-all-dev libspdlog-dev libfmt-dev

rm -rf "$MUJOCO_DIR"
mkdir -p "$MUJOCO_DIR"

cd /tmp
rm -rf mujoco.tar.gz "mujoco-${MUJOCO_VERSION}"
wget -O mujoco.tar.gz \
  "https://github.com/google-deepmind/mujoco/releases/download/${MUJOCO_VERSION}/mujoco-${MUJOCO_VERSION}-linux-x86_64.tar.gz"

tar -xzf mujoco.tar.gz
cp -r "mujoco-${MUJOCO_VERSION}/"* "$MUJOCO_DIR"/

export LD_LIBRARY_PATH="$MUJOCO_DIR/lib:${LD_LIBRARY_PATH}"

cd "$SIMULATE_DIR"
rm -rf build
mkdir build
cd build
cmake ..
make -j"$(nproc)"