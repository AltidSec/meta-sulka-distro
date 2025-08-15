SUMMARY = "Login and process accounting utilities"
DESCRIPTION = "The GNU Accounting Utilities provide login and process \
accounting utilities for GNU/Linux and other systems."
HOMEPAGE = "https://www.gnu.org/software/acct/"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

SRC_URI = " \
    ${GNU_MIRROR}/acct/acct-${PV}.tar.gz \
    file://0001-acct-6.6.4-cross-compile-fixed.patch \
    file://acct.sh \
    file://acct.service \
"

SRC_URI[sha256sum] = "4c15bf2b58b16378bcc83f70e77d4d40ab0b194acf2ebeefdb507f151faa663f"

inherit autotools update-alternatives update-rc.d systemd

ALTERNATIVE:${PN} = "last"
ALTERNATIVE_PRIORITY = "50"

do_install:append() {
    install -d ${D}/var/account
    touch ${D}/var/account/pacct

    if ${@bb.utils.contains('DISTRO_FEATURES','sysvinit','true','false',d)}; then
        install -d ${D}/${sysconfdir}/init.d

        install -m 755 ${WORKDIR}/acct.sh ${D}/${sysconfdir}/init.d/acct
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}/${systemd_unitdir}/system

        install -m 0644 ${WORKDIR}/acct.service ${D}${systemd_unitdir}/system
    fi
}

INITSCRIPT_NAME = "acct"
INITSCRIPT_PARAMS = "start 98 2 3 4 5 . stop 1 0 1 6 ."

SYSTEMD_SERVICE:${PN} = "acct.service"

FILES:${PN} += " \
    /var/account/pacct \
    ${systemd_unitdir}/system/acct.service \
"
