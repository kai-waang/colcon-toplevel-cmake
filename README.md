# Toplevel CMakeLists.txt for developing ROS 2 with CLion and colcon

CMake integration tools for developing ROS 2 workspaces with JetBrains CLion and colcon. Enables IDE analysis and highlighting while maintaining colcon's build system.

## Installation

Clone and run the interactive installer:

```bash
git clone https://github.com/kai-waang/colcon-toplevel-cmake /tmp/colcon-toplevel-cmake
cd /tmp/colcon-toplevel-cmake
./install.sh
```

The installer will prompt for:
- Installation directory (default: `/opt/ros/cmake`)
- Confirmation before proceeding
- Sudo permissions if needed

After installation, add an alias for convenience:

```bash
# Add to ~/.bashrc or ~/.zshrc
alias colcon-init='/opt/ros/cmake/init.sh'
```

## Usage

Initialize a ROS 2 workspace from the workspace root:

```bash
cd /path/to/your/ros2/workspace
colcon-init -n "my_project"
```

The `-n` flag sets the CMake project name (optional).

This creates a `CMakeLists.txt` with colcon integration, enabling CLion to parse and analyze your packages while colcon builds normally.

## Manual Usage

If you prefer manual setup:

```bash
cp /opt/ros/cmake/toplevel.cmake /path/to/your/workspace/CMakeLists.txt
```

Then edit the project name: `project("your_project_name")`

## Acknowledgement

Modified from [this](https://gist.github.com/rotu/1eac858b808b82bbf1b475f515e91636).