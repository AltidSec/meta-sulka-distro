FILESEXTRAPATHS:prepend:sulka-harden-mounts := "${THISDIR}/${PN}:"

SRC_URI:append:sulka-harden-mounts = " file://0001-units-Mount-tmp-with-noexec.patch "
