#!/bin/bash

#if [ ! -f collection-harmonic.yaml ]; then wget https://raw.githubusercontent.com/gazebo-tooling/gazebodistro/master/collection-harmonic.yaml; fi

#vcs import < collection-harmonic.yaml
vcs import < gz-vendors.yaml
vcs import < ros2-ign.yaml

# apply a patch to the gz_ogre_vendor repo
cp patches/gz_ogre_next_vendor/fix-math-namespace.patch gz_ogre_next_vendor/patches/
sed -i "s|PATCHES|PATCHES\n    patches/fix-math-namespace.patch|" gz_ogre_next_vendor/CMakeLists.txt

# delete the directory since we don't want rosdep to pull the deps
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
