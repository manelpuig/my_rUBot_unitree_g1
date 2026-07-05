# **Unitree setup**

- Clone the repository and run the setup script to set up your workspace:

```bash
git clone https://github.com/unitree/unitree_g1.git
cd unitree_g1
chmod +x Documentation/Files/scripts/setup_workspace.sh
./Documentation/Files/scripts/setup_workspace.sh
```
- Compile:

```bash
colcon build --symlink-install
```

