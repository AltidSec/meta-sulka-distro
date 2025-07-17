#!/bin/sh
### BEGIN INIT INFO
# Provides:          acct
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: GNU process accounting
# Description:       Enable process accounting with accton
### END INIT INFO

case "$1" in
  start)
    accton on
    ;;
  stop)
    accton off
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac
