FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://0001-initscripts-Fix-date-call-in-bootmisc.patch;patchdir=${UNPACKDIR}"
