FILESEXTRAPATHS:prepend:sulka-hardening := "${THISDIR}/${PN}:"

SRC_URI:append:sulka-hardening = " file://disable_modules.conf"

do_install:append:sulka-hardening () {
    install -m 0644 ${WORKDIR}/disable_modules.conf ${D}${sysconfdir}/modprobe.d
}
