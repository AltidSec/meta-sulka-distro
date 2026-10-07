FILESEXTRAPATHS:prepend:sulka-hardening := "${THISDIR}/files:"

SRC_URI:append:sulka-hardening = " file://0001-initscripts-Fix-bootmisc-date-calls.patch;patchdir=${WORKDIR} "
