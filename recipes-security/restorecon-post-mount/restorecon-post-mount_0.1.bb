SUMMARY = "Run SELinux restorecon after mounts"
DESCRIPTION = "Initscript that runs SELinux restorecon on configured paths after \
filesystems are mounted."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://restorecon-post-mount.sh"

inherit update-rc.d

do_configure[noexec] = "1"
do_compile[noexec] = "1"

RESTORECON_RECURSIVE_PATHS ?= "/var/volatile /run /var/lib /var/volatile/log /var/volatile/tmp"
RESTORECON_NONRECURSIVE_PATHS ?= ""

do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -m 755 ${UNPACKDIR}/restorecon-post-mount.sh ${D}${sysconfdir}/init.d/0restorecon-post-mount
    sed -i 's|@RESTORECON_RECURSIVE_PATHS@|${RESTORECON_RECURSIVE_PATHS}|g' ${D}${sysconfdir}/init.d/0restorecon-post-mount
    sed -i 's|@RESTORECON_NONRECURSIVE_PATHS@|${RESTORECON_NONRECURSIVE_PATHS}|g' ${D}${sysconfdir}/init.d/0restorecon-post-mount
}

# The leading 0 is required for the ordering purposes. The script should run after S37populate-volatile
# but before S38dmesg.sh, so the script name is prefixed with 0 to make it run in between them
INITSCRIPT_NAME = "0restorecon-post-mount"
INITSCRIPT_PARAMS = "start 38 S ."
