# G1 Motion Examples

This package contains simple motion-control examples for the **Unitree G1** in MuJoCo simulation.

The goal is not yet to implement full humanoid balance, but to understand the first control layer:

```text
YAML pose file
      ↓
g1_pose_player
      ↓
Unitree LowCmd
      ↓
MuJoCo G1 simulation
```

## Package structure

```text
my_g1_examples/
├── config/
│   └── g1_poses.yaml
├── my_g1_examples/
│   └── g1_pose_player.py
├── package.xml
└── setup.py
```

## What the node does

The node `g1_pose_player`:

- reads a target pose from `g1_poses.yaml`;
- assigns a desired position to each G1 joint;
- sends continuous `LowCmd` commands to MuJoCo;
- applies simple joint-space PD control using `kp` and `kd`.

Example command:

```bash
ros2 run my_g1_examples g1_pose_player --ros-args -p pose:=stand
```

The selected pose is defined in:

```text
my_g1_examples/config/g1_poses.yaml
```

Example:

```yaml
stand:
  kp: 80.0
  kd: 4.0
  joints:
    left_hip_pitch: -0.35
    left_knee: 0.70
    left_ankle_pitch: -0.35
    right_hip_pitch: -0.35
    right_knee: 0.70
    right_ankle_pitch: -0.35
```

## Launching the G1 in MuJoCo

Open a first terminal:

```bash
cd ~/my_rUBot_unitree_g1
bash Documentation/Files/scripts/run_g1_mujoco.sh
```

This launches the official Unitree MuJoCo simulator with the G1 29-DoF model.

## Running the pose player

Open a second terminal:

```bash
cd ~/my_rUBot_unitree_g1
source install/setup.bash

ros2 run my_g1_examples g1_pose_player --ros-args -p pose:=stand
```

Both MuJoCo and the pose player must use the same DDS domain and network interface.

In this project we use:

```text
domain_id = 0
network_interface = lo
```

## Current behaviour

With the current implementation, the robot joints become stiff and try to hold the requested pose.

However, the robot may still fall forward or backward.

This is expected.

The current controller is only a **joint-space position controller**. It does not yet control balance.

## Why the robot falls

A humanoid robot cannot remain standing only by fixing joint angles.

To stand reliably, the controller must also consider:

- centre of mass position;
- foot contact forces;
- pelvis orientation;
- body inclination;
- IMU feedback;
- ankle and hip corrections;
- whole-body dynamics.

At the moment, the controller does not use the IMU or any balance feedback.

## Next development step

The next step is to add a simple balance controller using the simulated IMU.

A first improvement could be:

```text
if the torso falls forward:
    correct hip_pitch and ankle_pitch

if the torso falls backward:
    correct hip_pitch and ankle_pitch in the opposite direction
```

This would become a first simplified balance controller.

A more advanced solution would be to implement or integrate a **Whole-Body Controller (WBC)**.

A WBC can coordinate the whole humanoid body by controlling tasks such as:

- keeping both feet on the ground;
- keeping the centre of mass inside the support polygon;
- keeping the torso upright;
- moving the arms or head while preserving balance.

## Summary

This package is the first step towards G1 humanoid motion control:

```text
1. MuJoCo simulation                  done
2. LowCmd communication               done
3. YAML-based joint poses             done
4. Joint-space PD posture control     done
5. IMU-based balance control          next
6. Whole-Body Control                 future work
```