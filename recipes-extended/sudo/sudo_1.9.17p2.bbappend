SRC_URI:append:sulka = " file://serviceuser.conf"
FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/files:"

do_install:append:sulka () {
    install -m 440 ${UNPACKDIR}/serviceuser.conf ${D}${sysconfdir}/sudoers.d/serviceuser
    sed -i "s/@@SULKA_SERVICEUSER_USERNAME@@/${SULKA_SERVICEUSER_USERNAME}/g" ${D}${sysconfdir}/sudoers.d/serviceuser

    if [ "${SULKA_SERVICEUSER_ENABLE_SUDO}" -eq 1 ]; then
       sed -i "/^# Defaults:/s/^# //"                     ${D}${sysconfdir}/sudoers.d/serviceuser
       sed -i "/^# ${SULKA_SERVICEUSER_USERNAME}/s/^# //" ${D}${sysconfdir}/sudoers.d/serviceuser
    fi
}
