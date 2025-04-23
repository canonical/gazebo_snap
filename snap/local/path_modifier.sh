#!/bin/bash

# Save off parameters before any manipulation
original_args=("$@")

SNAP_LIB_PATH="$SNAP/usr/local/lib/:$SNAP/usr/local/lib/$CRAFT_ARCH_TRIPLET_BUILD_FOR/:$SNAP/usr/lib/:$SNAP/usr/lib/$CRAFT_ARCH_TRIPLET_BUILD_FOR/"
RUBY_LIB_PATH="$SNAP/usr/local/lib/site_ruby/3.2.0:$SNAP/usr/local/lib/$CRAFT_ARCH_TRIPLET_BUILD_FOR/site_ruby:$SNAP/usr/local/lib/site_ruby:$SNAP/usr/lib/ruby/vendor_ruby/3.2.0:$SNAP/usr/lib/$CRAFT_ARCH_TRIPLET_BUILD_FOR/ruby/vendor_ruby/3.2.0:$SNAP/usr/lib/ruby/vendor_ruby:$SNAP/usr/lib/ruby/3.2.0:$SNAP/usr/lib/$CRAFT_ARCH_TRIPLET_BUILD_FOR/ruby/3.2.0"
export LD_LIBRARY_PATH=$SNAP_LIB_PATH:$RUBY_LIB_PATH:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

exec "${original_args[@]}"
