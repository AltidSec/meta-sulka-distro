FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://limits.d/disable_core_dumps.conf"

do_install:append () {
    install -m 0644 ${WORKDIR}/limits.d/disable_core_dumps.conf ${D}${sysconfdir}/security/limits.d/
}
