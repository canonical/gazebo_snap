#!/bin/bash

vcs import < gz-vendors.yaml
vcs import < ros2-gz.yaml

# patches to remove CMAKE_INSTALL_PATH inserted in the libraries
cp patches/gz_rendering_vendor/remove_cmake_gz_rendering_plugin_path.patch gz_libs/gz_rendering_vendor/patches/
cp patches/gz_rendering_vendor/remove_install_path_search.patch gz_libs/gz_rendering_vendor/patches/

# delete the directories we don't intend to build to prevent rosdep from pulling their deps
rm -rf gz_ros2_control/gz_ros2_control_demos
rm -rf gz_ros2_control/gz_ros2_control_tests
rm -rf ros_gz/ros_gz_sim_demos
rm -rf ros_gz/ros_ign_gazebo_demos
rm -rf ros2_control/hardware_interface_testing
rm -rf ros2_control/rqt_controller_manager

# we removed hardware_testing from the packages
sed -i '/hardware_interface_testing/d' ros2_control/controller_manager/package.xml
# we removed ros_gz_sim_demos from the packages since it pulls RViz
sed -i '/ros_gz_sim_demos/d' ros_gz/ros_gz/package.xml
