#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "$WORKSPACE_DIR/src/unitree_mujoco/simulate/build"

export LD_LIBRARY_PATH="../mujoco/lib:${LD_LIBRARY_PATH}"

./unitree_mujoco -r g1 -s scene_29dof.xml