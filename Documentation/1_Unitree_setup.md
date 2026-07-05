# **Unitree setup**

- In Host PC, clone the repository and run the setup script to set up your workspace:

```bash
git clone https://github.com/github_user/my_rUBot_unitree_g1/unitree_g1.git
cd Documentation/Files/Docker_Humble
docker compose up
````

- In Docker Container, clone the repository and run the setup script to set up your workspace:

```bash
git clone https://github.com/github_user/my_rUBot_unitree_g1/unitree_g1.git
cd unitree_g1
chmod +x Documentation/Files/scripts/setup_workspace.sh
bash Documentation/Files/scripts/setup_workspace.sh
```
- Compile:

```bash
colcon build --symlink-install
```

