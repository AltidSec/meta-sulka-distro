#!/bin/sh
### BEGIN INIT INFO
# Provides:          restorecon-post-mount
# Required-Start:    $local_fs
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: SELinux restorecon after mounts
# Description:       Run SELinux restorecon on configured paths after filesystems
#                    are mounted.
### END INIT INFO

RESTORECON_RECURSIVE_PATHS="@RESTORECON_RECURSIVE_PATHS@"
RESTORECON_NONRECURSIVE_PATHS="@RESTORECON_NONRECURSIVE_PATHS@"

case "$1" in
  start)
    RESTORECON=$(command -v restorecon)
    if [ -z "$RESTORECON" ]; then
        echo "restorecon command not found, skipping SELinux relabeling"
        exit 0
    fi

    for path in $RESTORECON_RECURSIVE_PATHS; do
        if [ -e "$path" ]; then
            "$RESTORECON" -RF "$path"
        fi
    done

    for path in $RESTORECON_NONRECURSIVE_PATHS; do
        if [ -e "$path" ]; then
            "$RESTORECON" -F "$path"
        fi
    done
    ;;
  *)
    echo "Usage: $0 {start}"
    exit 1
    ;;
esac
