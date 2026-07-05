#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "$WORKSPACE_DIR"

echo "=== Sourcing ROS2 Humble ==="
source /opt/ros/humble/setup.bash

echo "=== Installing basic tools ==="
apt update
apt install -y \
  git \
  python3-vcstool \
  python3-rosdep \
  python3-colcon-common-extensions

echo "=== Initializing rosdep if needed ==="
sudo rosdep init 2>/dev/null || true
rosdep update || true

echo "=== Importing Unitree repositories ==="
vcs import . < "${SCRIPT_DIR}/unitree_g1.repos"

echo "=== Installing ROS dependencies ==="
rosdep install --from-paths src --ignore-src -r -y || true

echo "=== Building workspace ==="
colcon build --symlink-install

echo "=== Done ==="
echo "Run:"
echo "source install/setup.bash"