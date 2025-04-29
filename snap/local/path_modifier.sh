#!/bin/bash

# Save off parameters before any manipulation
original_args=("$@")

if [ "$SNAP_ARCH" = "amd64" ]; then
  ARCH_TRIPLET="x86_64-linux-gnu"
elif [ "$SNAP_ARCH" = "armhf" ]; then
  ARCH_TRIPLET="arm-linux-gnueabihf"
elif [ "$SNAP_ARCH" = "arm64" ]; then
  ARCH_TRIPLET="aarch64-linux-gnu"
elif [ "$SNAP_ARCH" = "ppc64el" ]; then
  ARCH_TRIPLET="powerpc64le-linux-gnu"
else
  ARCH_TRIPLET="$SNAP_ARCH-linux-gnu"
fi

SNAP_LIB_PATH="$SNAP/usr/local/lib/:$SNAP/usr/local/lib/$ARCH_TRIPLET/:$SNAP/usr/lib/:$SNAP/usr/lib/$ARCH_TRIPLET/:$SNAP/usr/lib/$ARCH_TRIPLET/blas:$SNAP/usr/lib/$ARCH_TRIPLET/lapack"
RUBY_LIB_PATH="$SNAP/usr/local/lib/site_ruby/3.2.0:$SNAP/usr/local/lib/$ARCH_TRIPLET/site_ruby:$SNAP/usr/local/lib/site_ruby:$SNAP/usr/lib/ruby/vendor_ruby/3.2.0:$SNAP/usr/lib/$ARCH_TRIPLET/ruby/vendor_ruby/3.2.0:$SNAP/usr/lib/ruby/vendor_ruby:$SNAP/usr/lib/ruby/3.2.0:$SNAP/usr/lib/$ARCH_TRIPLET/ruby/3.2.0"
export LD_LIBRARY_PATH=$SNAP_LIB_PATH:$RUBY_LIB_PATH:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=$SNAP_LIB_PATH:$RUBY_LIB_PATH:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}


exec "${original_args[@]}"
