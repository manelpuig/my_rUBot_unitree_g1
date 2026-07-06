#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "$WORKSPACE_DIR/src/unitree_sdk2/build"

unset AMENT_PREFIX_PATH
unset COLCON_PREFIX_PATH
unset ROS_PACKAGE_PATH
unset ROS_DISTRO
unset ROS_VERSION
unset ROS_PYTHON_VERSION

export LD_LIBRARY_PATH="/usr/local/lib:$WORKSPACE_DIR/src/unitree_mujoco/simulate/mujoco/lib:$LD_LIBRARY_PATH"

echo "Running G1 ankle swing example..."
./bin/g1_ankle_swing_example lo