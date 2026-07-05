#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

MUJOCO_VERSION="3.2.7"
SIMULATE_DIR="$WORKSPACE_DIR/src/unitree_mujoco/simulate"
MUJOCO_DIR="$SIMULATE_DIR/mujoco"

cd "$WORKSPACE_DIR"

echo "=== Installing MuJoCo/Unitree dependencies ==="
apt update
apt install -y \
  wget \
  unzip \
  cmake \
  build-essential \
  libglfw3-dev \
  libglew-dev \
  libyaml-cpp-dev \
  libeigen3-dev \
  libboost-all-dev \
  libspdlog-dev \
  libfmt-dev

echo "=== Installing MuJoCo C++ library inside unitree_mujoco/simulate ==="
rm -rf "$MUJOCO_DIR"
mkdir -p "$MUJOCO_DIR"

cd /tmp
rm -rf mujoco.tar.gz "mujoco-${MUJOCO_VERSION}"

wget -O mujoco.tar.gz \
  "https://github.com/google-deepmind/mujoco/releases/download/${MUJOCO_VERSION}/mujoco-${MUJOCO_VERSION}-linux-x86_64.tar.gz"

tar -xzf mujoco.tar.gz

# Copy MuJoCo contents into the location expected by unitree_mujoco
cp -r "mujoco-${MUJOCO_VERSION}/"* "$MUJOCO_DIR"/

export LD_LIBRARY_PATH="$MUJOCO_DIR/lib:${LD_LIBRARY_PATH}"

echo "=== Checking MuJoCo files ==="
ls "$MUJOCO_DIR/include/mujoco/mujoco.h"
ls "$MUJOCO_DIR/lib/libmujoco.so"

echo "=== Building unitree_mujoco manually ==="
cd "$SIMULATE_DIR"
rm -rf build
mkdir build
cd build

cmake ..
make -j"$(nproc)"

echo "=== Unitree MuJoCo build completed ==="

echo "=== Creating G1 MuJoCo launcher ==="

cat > "$SCRIPT_DIR/run_g1_mujoco.sh" << 'EOF'
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "$WORKSPACE_DIR/src/unitree_mujoco/simulate/build"

export LD_LIBRARY_PATH="../mujoco/lib:${LD_LIBRARY_PATH}"

./unitree_mujoco -r g1 -s scene_29dof.xml
EOF

chmod +x "$SCRIPT_DIR/run_g1_mujoco.sh"