#!/usr/bin/env python3

import os
import time
import yaml
import rclpy

from rclpy.node import Node
from ament_index_python.packages import get_package_share_directory

from unitree_sdk2py.core.channel import ChannelFactoryInitialize, ChannelPublisher
from unitree_sdk2py.idl.unitree_hg.msg.dds_ import LowCmd_
from unitree_sdk2py.idl.default import unitree_hg_msg_dds__LowCmd_


G1_JOINT_NAMES = [
    "left_hip_pitch", "left_hip_roll", "left_hip_yaw",
    "left_knee", "left_ankle_pitch", "left_ankle_roll",
    "right_hip_pitch", "right_hip_roll", "right_hip_yaw",
    "right_knee", "right_ankle_pitch", "right_ankle_roll",
    "waist_yaw", "waist_roll", "waist_pitch",
    "left_shoulder_pitch", "left_shoulder_roll", "left_shoulder_yaw",
    "left_elbow", "left_wrist_roll", "left_wrist_pitch", "left_wrist_yaw",
    "right_shoulder_pitch", "right_shoulder_roll", "right_shoulder_yaw",
    "right_elbow", "right_wrist_roll", "right_wrist_pitch", "right_wrist_yaw",
]


class G1PosePlayer(Node):
    def __init__(self):
        super().__init__("g1_pose_player")

        self.declare_parameter("pose", "stand")
        self.declare_parameter("poses_file", "")
        self.declare_parameter("domain_id", 0)
        self.declare_parameter("network_interface", "lo")
        self.declare_parameter("rate_hz", 500.0)
        self.declare_parameter("topic", "rt/lowcmd")

        pose_name = self.get_parameter("pose").value
        poses_file = self.get_parameter("poses_file").value
        domain_id = int(self.get_parameter("domain_id").value)
        network_interface = self.get_parameter("network_interface").value
        rate_hz = float(self.get_parameter("rate_hz").value)
        topic = self.get_parameter("topic").value

        if poses_file == "":
            pkg_share = get_package_share_directory("my_g1_examples")
            poses_file = os.path.join(pkg_share, "config", "g1_poses.yaml")

        with open(poses_file, "r") as f:
            poses = yaml.safe_load(f)

        if pose_name not in poses:
            raise RuntimeError(f"Pose '{pose_name}' not found in {poses_file}")

        pose = poses[pose_name]
        joints = pose.get("joints", {})

        kp = float(pose.get("kp", 80.0))
        kd = float(pose.get("kd", 4.0))

        self.dt = 1.0 / rate_hz

        ChannelFactoryInitialize(domain_id, network_interface)

        self.publisher = ChannelPublisher(topic, LowCmd_)
        self.publisher.Init()

        self.cmd = unitree_hg_msg_dds__LowCmd_()

        for i, joint_name in enumerate(G1_JOINT_NAMES):
            q_des = float(joints.get(joint_name, 0.0))

            self.cmd.motor_cmd[i].mode = 1
            self.cmd.motor_cmd[i].q = q_des
            self.cmd.motor_cmd[i].dq = 0.0
            self.cmd.motor_cmd[i].kp = kp
            self.cmd.motor_cmd[i].kd = kd
            self.cmd.motor_cmd[i].tau = 0.0

        self.get_logger().info(f"Playing G1 pose: {pose_name}")
        self.get_logger().info(f"Pose file: {poses_file}")
        self.get_logger().info(f"DDS domain_id: {domain_id}")
        self.get_logger().info(f"DDS interface: {network_interface}")
        self.get_logger().info(f"DDS topic: {topic}")
        self.get_logger().info(f"Control rate: {rate_hz} Hz")

    def run(self):
        try:
            while rclpy.ok():
                self.publisher.Write(self.cmd)
                time.sleep(self.dt)
        except KeyboardInterrupt:
            pass


def main(args=None):
    rclpy.init(args=args)
    node = G1PosePlayer()
    node.run()
    node.destroy_node()
    rclpy.shutdown()


if __name__ == "__main__":
    main()