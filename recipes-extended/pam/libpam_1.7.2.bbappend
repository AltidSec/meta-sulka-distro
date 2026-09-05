FILESEXTRAPATHS:prepend:sulka-hardening := "${THISDIR}/${PN}:"

SRC_URI:append:sulka-hardening = " file://limits.d/disable_core_dumps.conf"

do_install:append:sulka-hardening () {
    install -m 0644 ${UNPACKDIR}/limits.d/disable_core_dumps.conf ${D}${sysconfdir}/security/limits.d/
}
