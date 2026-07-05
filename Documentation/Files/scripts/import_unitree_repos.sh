#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "$WORKSPACE_DIR"

echo "=== Importing Unitree repositories ==="
vcs import . < "${SCRIPT_DIR}/unitree_g1.repos"