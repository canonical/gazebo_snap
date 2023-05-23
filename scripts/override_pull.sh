#!/bin/bash
      if [ ! -f collection-fortress.yaml ]; then wget https://raw.githubusercontent.com/gazebo-tooling/gazebodistro/master/collection-fortress.yaml; fi
      vcs import < collection-fortress.yaml
      vcs import < ros2-ign.yaml

      # delete the directory since we don't want rosdep to pull the deps
      rm -rf ign_ros2_control/ign_ros2_control_demos

      # delete the directory since we don't want rosdep to pull the deps
      rm -rf ros_gz/ros_ign_gazebo_demos ros_gz/ros_gz_sim_demos
      # temporary, it depends on some odds version of ign libs, https://github.com/gazebosim/ros_gz/issues/40
      rm -rf ros_gz/ros_ign_point_cloud ros_gz/ros_gz_point_cloud

      # you can use fake_package_xml_generator to prepare a draft for gz_packages_XML based on the output of vcs import
      # python3 scripts/fake_package_generator.py [folder_where_vcs_imported_gz_repos]

      # place artifical package.xml files in ign directories
      ls gz_packages_XML | awk -F. '{printf("mv gz_packages_XML/%s.xml %s/package.xml\n", $1, $1)}' | sh

      sed -i "s|\${CMAKE_INSTALL_PREFIX}|/snap/$SNAPCRAFT_PROJECT_NAME/current/opt/ros/snap|" gz-gui/include/gz/gui/config.hh.in
      sed -i "s|\${CMAKE_INSTALL_PREFIX}|/snap/$SNAPCRAFT_PROJECT_NAME/current/opt/ros/snap|" gz-sim/include/gz/sim/config.hh.in

      # artificial ign package.xml are not "installed" so rosdep try to redownload them
      sed -i 's|<depend>ignition-plugin<\/depend>|<build_depend>ignition-plugin1<\/build_depend>|' ign_ros2_control/ign_ros2_control/package.xml
      sed -i '/ignition-.*<\/depend/s/depend/build_depend/g' ign_ros2_control/ign_ros2_control/package.xml
      find ros_gz -name package.xml -exec sed -i '/ignition-.*<\/depend/s/depend/build_depend/g' {} \;

      sed -i '/ros_ign_gazebo_demos/d' ros_gz/ros_ign/package.xml
      sed -i '/ros_gz_sim_demos/d' ros_gz/ros_gz/package.xml
      