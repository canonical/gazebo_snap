#!/bin/bash -e

LD_LIBRARY_PATH="/snap/gazebo/current/opt/ros/snap/lib:/snap/gazebo/current/opt/ros/foxy/opt/yaml_cpp_vendor/lib:/snap/gazebo/current/opt/ros/foxy/lib/x86_64-linux-gnu:/snap/gazebo/current/opt/ros/foxy/lib:/var/lib/snapd/lib/gl:/var/lib/snapd/lib/gl32:/var/lib/snapd/void:/snap/gazebo/current/lib:/snap/gazebo/current/usr/lib:/snap/gazebo/current/lib/x86_64-linux-gnu:/snap/gazebo/current/usr/lib/x86_64-linux-gnu:/snap/gazebo/current/kf5/lib/x86_64-linux-gnu:/snap/gazebo/current/kf5/usr/lib/x86_64-linux-gnu:/snap/gazebo/current/kf5/usr/lib:/snap/gazebo/current/kf5/lib:/snap/gazebo/current/kf5/usr/lib/x86_64-linux-gnu/dri:/var/lib/snapd/lib/gl:/snap/gazebo/current/kf5/usr/lib/x86_64-linux-gnu/pulseaudio"


# delete empty entries in the LD_LIBRARY_PATH
# i.e. change "/a/b/c:/1/2/3::/other" into "/a/b/c:/1/2/3:/other"
# if we don't do this, then ldconfig gets confused with "" as arguments of dirs
# to add to the cache
LD_LIBRARY_PATH="${LD_LIBRARY_PATH//::/:}"
# Remove leading empty element if it exists
LD_LIBRARY_PATH="${LD_LIBRARY_PATH#:}"
# Remove trailing empty element if it exists
LD_LIBRARY_PATH="${LD_LIBRARY_PATH%:}"

# run ldconfig on our LD_LIBRARY_PATH lib dirs
IFS=':' read -ra PATHS <<< "$LD_LIBRARY_PATH"
mkdir -p "$SNAP_DATA/etc"
ldconfig -v -X -C "$SNAP_USER_DATA/snap-ld.so.cache" -f "$SNAP_DATA/etc/ld.so.conf" "${PATHS[@]}"
cat "$SNAP_USER_DATA/snap-ld.so.cache" > "$SNAP_DATA/etc/ld.so.cache"

