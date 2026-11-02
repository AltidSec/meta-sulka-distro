FILESEXTRAPATHS:prepend:sulka-hardening := "${THISDIR}/files:"

SRC_URI:append:sulka-hardening = " file://0001-initscripts-Fix-date-call-in-bootmisc.patch;patchdir=${UNPACKDIR}"

# The hardened mount options in fstab are not applied to the file systems
# that an initramfs has already mounted, such as /proc and /run, so
# remount them with the options in fstab after mountall.sh.
SRC_URI:append:sulka-harden-mounts = " file://remountvirtfs.sh"

do_install:append:sulka-harden-mounts () {
    install -m 0755 ${UNPACKDIR}/remountvirtfs.sh ${D}${sysconfdir}/init.d
    update-rc.d -r ${D} remountvirtfs.sh start 03 S .
}
