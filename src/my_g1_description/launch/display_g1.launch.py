from launch import LaunchDescription
from launch_ros.actions import Node
from pathlib import Path
from ament_index_python.packages import get_package_share_directory


def generate_launch_description():
    pkg_path = Path(get_package_share_directory("my_g1_description"))
    urdf_file = pkg_path / "urdf" / "g1_29dof.urdf"
    rviz_config = pkg_path / "rviz" / "g1.rviz"

    robot_description = urdf_file.read_text()

    return LaunchDescription([
        Node(
            package="robot_state_publisher",
            executable="robot_state_publisher",
            parameters=[{"robot_description": robot_description}],
            output="screen",
        ),
        Node(
            package="joint_state_publisher_gui",
            executable="joint_state_publisher_gui",
            output="screen",
        ),

        Node(
            package="rviz2",
            executable="rviz2",
            arguments=["-d", str(rviz_config)],
            output="screen",
        ),
    ])