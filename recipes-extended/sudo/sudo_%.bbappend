SRC_URI:append:sulka = " file://serviceuser.conf"
FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/files:"

do_install:append:sulka () {
    install -m 440 ${WORKDIR}/serviceuser.conf ${D}${sysconfdir}/sudoers.d/serviceuser
    sed -i  "s/@@SULKA_SERVICEUSER_USERNAME@@/${SULKA_SERVICEUSER_USERNAME}/g" ${D}${sysconfdir}/sudoers.d/serviceuser
}

FILES_${PN}:sulka += " ${sysconfdir}/sudoers.d/serviceuser"
