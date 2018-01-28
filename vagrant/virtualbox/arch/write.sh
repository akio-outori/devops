#!/bin/bash

# Write an iso file to the specified drive
ISO="$1"
DISK="$2"

function usage() {
  echo "Something went wrong.."
  echo "Usage:"
  echo "write.sh <file.iso> </dev/sdx>"
  exit 1
}

# Check to make sure the image file and destination disk were specified
if [ -z "$ISO" ] || [ -z "$DISK" ]; then
  usage
fi

# Burn the iso image to disk
dd bs=4M if=$ISO of=$DISK status=progress && sync || usage
