#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

CONFIG_FILE="$WORKSPACE_DIR/src/unitree_mujoco/simulate/config.yaml"
MUJOCO_BUILD_DIR="$WORKSPACE_DIR/src/unitree_mujoco/simulate/build"

echo "Configuring Unitree MuJoCo for G1..."

sed -i 's/^robot:.*/robot: "g1"  # Robot name, "go2", "b2", "b2w", "h1", "go2w", "g1", "h2"/' "$CONFIG_FILE"
sed -i 's/^robot_scene:.*/robot_scene: "scene_29dof.xml" # Robot scene/' "$CONFIG_FILE"
sed -i 's/^domain_id:.*/domain_id: 0  # Domain id/' "$CONFIG_FILE"
sed -i 's/^interface:.*/interface: "lo" # Interface/' "$CONFIG_FILE"
sed -i 's/^enable_elastic_band:.*/enable_elastic_band: 1 # Virtual spring band, used for lifting humanoids/' "$CONFIG_FILE"
sed -i 's/^print_scene_information:.*/print_scene_information: 1 # Print link, joint and sensors information of robot/' "$CONFIG_FILE"

cd "$MUJOCO_BUILD_DIR"

unset AMENT_PREFIX_PATH
unset COLCON_PREFIX_PATH
unset ROS_PACKAGE_PATH
unset ROS_DISTRO
unset ROS_VERSION
unset ROS_PYTHON_VERSION

export ROS_DOMAIN_ID=0
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export LD_LIBRARY_PATH="/usr/local/lib:../mujoco/lib:$LD_LIBRARY_PATH"

echo "Launching Unitree MuJoCo G1 29-DOF on domain ${ROS_DOMAIN_ID}..."
./unitree_mujoco -r g1 -s scene_29dof.xml -i "$ROS_DOMAIN_ID" -n lo