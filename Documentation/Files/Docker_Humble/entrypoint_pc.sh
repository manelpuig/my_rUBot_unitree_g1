#!/bin/bash
set -e

# Source ROS 2 Humble
source /opt/ros/humble/setup.bash

# Source workspace if present
if [ -f /root/my_rUBot_unitree_g1/install/setup.bash ]; then
  source /root/my_rUBot_unitree_g1/install/setup.bash
fi

# DDS / ROS 2 networking (clear & explicit)
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# Teaching banner
echo "=============================================="
echo " ROS 2 Humble - Docker PC"
echo "----------------------------------------------"
echo " ROS_DOMAIN_ID               = $ROS_DOMAIN_ID"
echo "=============================================="

exec "$@"
