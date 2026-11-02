#!/bin/sh
#
# SPDX-License-Identifier: MIT
#

### BEGIN INIT INFO
# Provides:          remountvirtfs
# Required-Start:    mountall
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: Apply the fstab options to the virtual file systems.
# Description:       An initramfs mounts /proc, /sys, /dev and /run and moves
#                    them to the root file system. mountall.sh skips file
#                    systems that are already mounted, so their options in
#                    /etc/fstab are not applied. Remount them with the
#                    options in /etc/fstab.
### END INIT INFO

while read -r device dir type options rest; do
	# Skip the comments
	case "$device" in
		\#*) continue ;;
	esac

	case "$dir" in
		/proc|/sys|/dev|/run)
			if mountpoint -q "$dir"; then
				mount -o remount,"$options" "$dir"
			fi
			;;
	esac
done < /etc/fstab

: exit 0
