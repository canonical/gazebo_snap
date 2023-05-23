#!/bin/bash
      echo $ROS_DISTRO
      ROS_DISTRO="humble"
      #### remove content sharing snap duplicate
      KDE_CONTENT_SNAP=$(echo $SNAPCRAFT_CMAKE_ARGS | sed -n 's/.*\/snap\/\(.*\)-sdk.*/\1/p')
      # remove duplicated files available in content snap
      for snap in "core22" $KDE_CONTENT_SNAP; do  # list all content-snaps and base snaps you're using here
          snap install $snap
          # we don't delete symlink
          cd "/snap/$snap/current/" && fdfind . --type f --exec rm -f "$SNAPCRAFT_PRIME/{}" \;
          # we delete symlink pointing to nowhere
          find "$SNAPCRAFT_PRIME" -xtype l -delete
      done
      ####

      #### remove unnecessary files
      # remove every header and source file
      fdfind --type file --type symlink '.*\.(hpp|hxx|h|hh|cpp|cxx|c|cc)$' $SNAPCRAFT_PRIME  --exec rm {}
      # remove every cmake file
      fdfind --type file --type symlink '(.cmake|CMakeLists.txt)$' $SNAPCRAFT_PRIME  --exec rm {}
      # remove every example(s) directories
      fdfind --type directory "^examples?$" $SNAPCRAFT_PRIME --exec rm -rf {}
      # remove man files
      rm -rf $SNAPCRAFT_PRIME/usr/share/man
      # remove doc files
      rm -rf $SNAPCRAFT_PRIME/usr/share/doc
      # remove perl share files
      rm -rf $SNAPCRAFT_PRIME/usr/share/perl
      # remove /usr/src/
      rm -rf $SNAPCRAFT_PRIME/usr/src
      # remove additional sources
      rm -rf $SNAPCRAFT_PRIME/opt/ros/${ROS_DISTRO}/src/
      ####

      #### remove unnecessary debian packages
      function remove-apt-package () {
        # because of the previous cleanup, we might have deleted headers that were installed by Debian packages, hence we ignore listing a file that no longer exist
        set +o pipefail
        $(dpkg -L $1 | xargs -I {} bash -c 'ls -ld $SNAPCRAFT_PRIME{} 2> /dev/null || true' | grep -v "^d" | awk '{print $NF}' | xargs rm -f)
        # remove empty directories
        $(dpkg -L $1 | xargs -I {} bash -c 'ls -ld $SNAPCRAFT_PRIME{} 2> /dev/null || true' | grep "^d" | tail -n +2 | awk '{print $NF}' | xargs -I {} rmdir --ignore-fail-on-non-empty {})
        set -o pipefail
      }

      function remove-apt-package-with-prefix () {
        for pkg in $(dpkg --get-selections "$1*" | awk '{print $1}')
        do
          remove-apt-package $pkg
        done
      }

      remove-apt-package ros-${ROS_DISTRO}-rosidl-adapter
      remove-apt-package ros-${ROS_DISTRO}-rosidl-generator-c
      remove-apt-package ros-${ROS_DISTRO}-rosidl-generator-cpp
      remove-apt-package ros-${ROS_DISTRO}-rosidl-generator-py
      remove-apt-package ros-${ROS_DISTRO}-ament-cmake-gmock
      remove-apt-package ros-${ROS_DISTRO}-python-cmake-module
      remove-apt-package python3-pytest

      # remove globs of packages
      remove-apt-package-with-prefix ros-${ROS_DISTRO}-ament-cmake
      remove-apt-package-with-prefix ros-${ROS_DISTRO}-testing
      remove-apt-package-with-prefix python3-colcon
      remove-apt-package-with-prefix python3-rosdep
      remove-apt-package-with-prefix cmake
      ####