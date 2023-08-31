#!/bin/bash

# Save off parameters before any manipulation
original_args=("$@")

SNAP_LIB_PATH="$SNAP/usr/local/lib/:$SNAP/usr/local/lib/$SNAPCRAFT_ARCH_TRIPLET/:$SNAP/usr/lib/:$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/"
RUBY_LIB_PATH="$SNAP/usr/local/lib/site_ruby/3.0.0:$SNAP/usr/local/lib/$SNAPCRAFT_ARCH_TRIPLET/site_ruby:$SNAP/usr/local/lib/site_ruby:$SNAP/usr/lib/ruby/vendor_ruby/3.0.0:$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/ruby/vendor_ruby/3.0.0:$SNAP/usr/lib/ruby/vendor_ruby:$SNAP/usr/lib/ruby/3.0.0:$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/ruby/3.0.0"
export LD_LIBRARY_PATH=$SNAP_LIB_PATH:$RUBY_LIB_PATH:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

exec "${original_args[@]}"
