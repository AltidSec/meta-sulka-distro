FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://0001-initscripts-Fix-bootmisc-date-calls.patch;patchdir=${WORKDIR} "
