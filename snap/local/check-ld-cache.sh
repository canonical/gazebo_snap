#!/bin/sh -e

# save the original LD_LIBRARY_PATH, and unset it to check the cache
ORIGINAL_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
# We cannot set LD_LIBRARY_PATH empty because rclutils is only looking into LD_LIBRARY_PATH for rmw impl lib
export LD_LIBRARY_PATH="/snap/gazebo/current/opt/ros/foxy/lib"

BINARY_TO_TEST="$SNAP/opt/ros/snap/lib/libignition-gazebo3-gui.so"

if [ -z "$BINARY_TO_TEST" ]; then
    echo "BINARY_TO_TEST unset, can't check the dynamic linker cache for correctness"
else
    # this is a bit tricky, we want to exit 0 if we didn't find a library, but
    # exit 1 if we didn't _not_ find a library, so use the output phrase
    # "=> not found" as what to look for from ldd
    # TODO: make this less of a hack?
    if ldd "$BINARY_TO_TEST" | grep "=> not found" | grep -q "=> not found"; then
        # We cannot regenerate the cache because we must be root.
	# So we use the LD_LIBRARY_PATH until the next hook is triggered
        export LD_LIBRARY_PATH="$ORIGINAL_LD_LIBRARY_PATH"
    fi
fi

# execute the next command in the chain
exec "$@"

