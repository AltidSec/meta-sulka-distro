FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/${PN}:"

SRC_URI:append:sulka = " file://limits.d/disable_core_dumps.conf"

do_install:append:sulka () {
    install -m 0644 ${UNPACKDIR}/limits.d/disable_core_dumps.conf ${D}${sysconfdir}/security/limits.d/
}
