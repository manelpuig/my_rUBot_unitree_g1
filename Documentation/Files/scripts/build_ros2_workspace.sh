#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "$WORKSPACE_DIR"

echo "=== Sourcing ROS2 Humble ==="
source /opt/ros/humble/setup.bash

echo "=== Installing ROS dependencies ==="
rosdep install --from-paths src --ignore-src -r -y || true

echo "=== Ignoring non-ROS / duplicated packages ==="
touch src/unitree_sdk2/COLCON_IGNORE || true
touch src/unitree_sdk2_python/COLCON_IGNORE || true
touch src/unitree_ros/COLCON_IGNORE || true
touch src/unitree_mujoco/COLCON_IGNORE || true
touch src/unitree_mujoco/example/cpp/COLCON_IGNORE || true

echo "=== Building ROS2 workspace ==="
colcon build --symlink-install