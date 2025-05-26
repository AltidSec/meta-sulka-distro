SRC_URI:append = " file://serviceuser.conf"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_install:append() {
    install -m 440 ${WORKDIR}/serviceuser.conf ${D}${sysconfdir}/sudoers.d/serviceuser
}

FILES_${PN} += " ${sysconfdir}/sudoers.d/serviceuser"
