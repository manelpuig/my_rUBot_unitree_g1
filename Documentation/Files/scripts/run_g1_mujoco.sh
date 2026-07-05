#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "$WORKSPACE_DIR/src/unitree_mujoco/simulate/build"

export LD_LIBRARY_PATH="/usr/local/lib:../mujoco/lib"

./unitree_mujoco -r g1 -s scene_29dof.xml -i 0 -n lo