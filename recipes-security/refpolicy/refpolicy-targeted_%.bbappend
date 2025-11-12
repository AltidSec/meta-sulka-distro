FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# nft command prints an error during boot on sysvinit systems
SRC_URI:append = "${@" file://0067-policy-modules-system-iptables-nftables-fixes.patch" if d.getVar('INIT_MANAGER') == "sysvinit" else ""}"
# sysvinit has a boot script that calls dmesg, this fails if busybox dmesg is used
SRC_URI:append = "${@" file://0068-policy-modules-admin-dmesg-Allow-dmesg-to-map-binaries.patch" if d.getVar('INIT_MANAGER') == "sysvinit" else ""}"
# sysstat cronjob requires adding permissions for the cronjobs, add if monitoring enabled
SRC_URI:append = "${@" file://0069-policy-modules-services-cron-Allow-more-permissions.patch" if d.getVar('SULKA_ENABLE_MONITORING') == "1" else ""}"
# sysvinit has a boot script that sets up interfaces, this fails with busybox tooling
SRC_URI:append = "${@" file://0070-policy-modules-system-sysnetwork-Allow-sysnetwork-to-map-binaries.patch" if d.getVar('INIT_MANAGER') == "sysvinit" else ""}"
# on systemd systems, rsyslog fails if the default non-persistent tmpfs logging location is used
SRC_URI:append = "${@" file://0071-policy-modules-system-logging-Allow-tmpfs-searches.patch" if d.getVar('INIT_MANAGER') == "systemd" else ""}"
# agetty on systemd systems attempts to search /dev/mqueue and /var/volatile, resulting in denials
SRC_URI:append = "${@" file://0072-policy-modules-system-getty-Allow-tmpfs-searches.patch" if d.getVar('INIT_MANAGER') == "systemd" else ""}"
# Allow changing the password during the log-in process
SRC_URI:append = " file://0073-policy-modules-system-locallogin-Allow-changing-password.patch "
# auditd needs permissions to create into the /var/run
SRC_URI:append = " file://0074-policy-modules-system-logging-Allow-auditd-to-create.patch "
