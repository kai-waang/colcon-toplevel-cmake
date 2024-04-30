# Toplevel CMakeLists.txt for developing ROS 2 with CLion and colcon

## Usage
Basically you can clone this repo into a common directory, e.g. `/opt/ros/scripts/cmake`
```bash
git clone https://github.com/kai-waang/colcon-toplevel-cmake /opt/ros/scripts/cmake
```

Then you can just create a `CMakeLists.txt` in your ROS 2 workspace root directory with the following content:
```cmake
cmake_minimum_required(VERSION 3.14)
project("ros2_project")

include("/opt/ros/scripts/cmake/colcon.cmake")

# only for clion highlighting and analysis
colcon_add_subdirectories(
        BUILD_BASE "${PROJECT_SOURCE_DIR}/build"
        BASE_PATHS "${PROJECT_SOURCE_DIR}/src/"
        # --packages-select  
)
```
Or you can just copy the `toplevel.cmake` from this repo to your workspace root directory.
```bash
cp /opt/ros/scripts/cmake/toplevel.cmake /path/to/your/ros2/workspace
```
**If you clone this in different directory as this repo, you should modify the `include(...)` correspondingly**
```cmake
# ...
include("/path/to/your/ros2/workspace/toplevel.cmake")
```

## Acknowledgement
This repo is a modified from [this](https://gist.github.com/rotu/1eac858b808b82bbf1b475f515e91636).