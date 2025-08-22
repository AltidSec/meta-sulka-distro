FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0067-policy-modules-system-iptables-nftables-fixes.patch \
"
SRC_URI:append = "${@" file://0068-policy-modules-admin-dmesg-Allow-dmesg-to-map-binaries.patch" if d.getVar('INIT_MANAGER') == "sysvinit" else ""}"
SRC_URI:append = "${@" file://0069-policy-modules-services-cron-Allow-more-permissions.patch" if d.getVar('SULKA_ENABLE_MONITORING') == "1" else ""}"
SRC_URI:append = "${@" file://0070-policy-modules-system-sysnetwork-Allow-sysnetwork-to-map-binaries.patch" if d.getVar('INIT_MANAGER') == "sysvinit" else ""}"
