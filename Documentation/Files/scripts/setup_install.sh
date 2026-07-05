#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "${SCRIPT_DIR}/install_ros2_dependencies.sh"
bash "${SCRIPT_DIR}/import_unitree_repos.sh"
bash "${SCRIPT_DIR}/install_unitree_mujoco.sh"
bash "${SCRIPT_DIR}/install_unitree_sdk.sh"
bash "${SCRIPT_DIR}/build_ros2_workspace.sh"

echo "=== Done ==="
echo "Run:"
echo "source install/setup.bash"
echo ""
echo "To launch G1 in MuJoCo:"
echo "bash ${SCRIPT_DIR}/run_g1_mujoco.sh"