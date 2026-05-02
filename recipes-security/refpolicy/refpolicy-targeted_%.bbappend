FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/${PN}:"

# nft command prints an error during boot on sysvinit systems
SRC_URI:append:sulka = "${@" file://0067-policy-modules-system-iptables-nftables-fixes.patch" if d.getVar('INIT_MANAGER') == "sysvinit" else ""}"
# sysvinit has a boot script that calls dmesg, this fails if busybox dmesg is used
SRC_URI:append:sulka = "${@" file://0068-policy-modules-admin-dmesg-Fixes-for-dmesg.patch" if d.getVar('INIT_MANAGER') == "sysvinit" else ""}"
# sysstat cronjob requires adding permissions for the cronjobs, add if monitoring enabled
SRC_URI:append:sulka = "${@" file://0069-policy-modules-services-cron-Allow-more-permissions.patch" if d.getVar('SULKA_ENABLE_MONITORING') == "1" else ""}"
# sysvinit has a boot script that sets up interfaces, this fails with busybox tooling
SRC_URI:append:sulka = "${@" file://0070-policy-modules-system-sysnetwork-Allow-sysnetwork-to-map-binaries.patch" if d.getVar('INIT_MANAGER') == "sysvinit" else ""}"
# Loosen up the security policy for the syslog-ng usage
SRC_URI:append:sulka = " file://0071-policy-modules-system-logging-Fixes-for-syslog-ng.patch "
# agetty on systemd systems attempts to search /dev/mqueue and /var/volatile, resulting in denials
SRC_URI:append:sulka = "${@" file://0072-policy-modules-system-getty-Allow-tmpfs-searches.patch" if d.getVar('INIT_MANAGER') == "systemd" else ""}"
# Allow changing the password during the log-in process
SRC_URI:append:sulka = " file://0073-policy-modules-system-locallogin-Allow-changing-password.patch "
# auditd needs more permissions to operate, so allow them
SRC_URI:append:sulka = " file://0074-policy-modules-system-logging-Auditd-fixes.patch "
# Allow changing the password during SSH log-in process. This is allowed by default only in development mode
SRC_URI:append:sulka = "${@" file://0075-policy-modules-system-ssh-Allow-changing-password.patch" if d.getVar('SULKA_DEVELOPMENT_MODE') == "1" else ""}"
# If SSH server is installed, ssh_sysadm_login tunable should be enabled
SRC_URI:append:sulka = "${@" file://0077-policy-modules-services-ssh-Allow-ssh_sysadm_login.patch" if bb.utils.contains('IMAGE_FEATURES', 'ssh-server-openssh', True, False, d) else ""}"
# With read-only-rootfs ssh_keygen needs access /run (or /var/run)
SRC_URI:append:sulka = "${@" file://0078-policy-modules-services-ssh-RO-FS-SSH-Fixes.patch" if bb.utils.contains('EXTRA_IMAGE_FEATURES', 'read-only-rootfs', True, False, d) else ""}"
