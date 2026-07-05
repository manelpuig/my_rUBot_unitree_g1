#!/bin/bash
set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$WORKSPACE_DIR"

echo "=== Sourcing ROS2 Humble ==="
source /opt/ros/humble/setup.bash

echo "=== Installing basic tools ==="
sudo apt update
sudo apt install -y \
  git \
  python3-vcstool \
  python3-rosdep \
  python3-colcon-common-extensions

echo "=== Initializing rosdep if needed ==="
sudo rosdep init 2>/dev/null || true
rosdep update || true

echo "=== Importing Unitree repositories ==="
vcs import . < unitree_g1.repos

echo "=== Installing ROS dependencies ==="
rosdep install --from-paths src --ignore-src -r -y || true

echo "=== Building workspace ==="
colcon build --symlink-install

echo "=== Done ==="
echo "Run:"
echo "source install/setup.bash"