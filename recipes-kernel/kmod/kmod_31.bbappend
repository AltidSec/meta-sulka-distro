FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/${PN}:"

SRC_URI:append:sulka = " file://disable_modules.conf"

do_install:append:sulka () {
    install -m 0644 ${WORKDIR}/disable_modules.conf ${D}${sysconfdir}/modprobe.d
}
