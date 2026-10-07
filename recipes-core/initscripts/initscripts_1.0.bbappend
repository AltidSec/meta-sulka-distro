FILESEXTRAPATHS:prepend:sulka-hardening := "${THISDIR}/files:"

SRC_URI:append:sulka-hardening = " file://0001-initscripts-Fix-date-call-in-bootmisc.patch;patchdir=${UNPACKDIR}"
