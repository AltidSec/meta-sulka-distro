FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://disable_modules.conf"

do_install:append () {
    install -m 0644 ${WORKDIR}/disable_modules.conf ${D}${sysconfdir}/modprobe.d
}
