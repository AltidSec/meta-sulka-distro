FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0067-policy-modules-system-iptables-nftables-fixes.patch \
"
