#!/bin/bash
set -e

echo "=== Sourcing ROS2 Humble ==="
source /opt/ros/humble/setup.bash

echo "=== Installing ROS2/basic tools ==="
apt update
apt install -y \
  git \
  python3-vcstool \
  python3-rosdep \
  python3-colcon-common-extensions \
  ros-humble-rosidl-generator-dds-idl

echo "=== Initializing rosdep if needed ==="
rosdep init 2>/dev/null || true
rosdep update || true