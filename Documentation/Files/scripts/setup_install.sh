#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "  Unitree G1 Workspace Installation"
echo "========================================"

bash "${SCRIPT_DIR}/install_ros2_dependencies.sh"
bash "${SCRIPT_DIR}/import_unitree_repos.sh"
bash "${SCRIPT_DIR}/install_unitree_sdk.sh"
bash "${SCRIPT_DIR}/install_unitree_mujoco.sh"
bash "${SCRIPT_DIR}/build_ros2_workspace.sh"

echo ""
echo "========================================"
echo " Installation completed successfully!"
echo "========================================"
echo ""
echo "Run:"
echo "source install/setup.bash"
echo ""
echo "Launch RViz:"
echo "ros2 launch my_g1_description display_g1.launch.py"
echo ""
echo "Launch MuJoCo:"
echo "bash ${SCRIPT_DIR}/run_g1_mujoco.sh"