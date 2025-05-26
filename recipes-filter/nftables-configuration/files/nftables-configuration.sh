#!/bin/sh
### BEGIN INIT INFO
# Provides:          nftables-configuration
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     S
# Default-Stop:      0 1 6
# Short-Description: nftables firewall rules
# Description:       Load nftables firewall rules
### END INIT INFO

RULESET_FILE="/etc/nftables.conf"

case "$1" in
  start)
    echo "Loading nftables rules..."
    nft -f "$RULESET_FILE"
    ;;
  stop)
    echo "Flushing nftables rules..."
    nft flush ruleset
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
