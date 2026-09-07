SRC_URI:append:sulka-hardening = " file://serviceuser.conf"
FILESEXTRAPATHS:prepend:sulka-hardening := "${THISDIR}/files:"

do_install:append:sulka-hardening () {
    install -m 440 ${WORKDIR}/serviceuser.conf ${D}${sysconfdir}/sudoers.d/serviceuser
    sed -i "s/@@SULKA_SERVICEUSER_USERNAME@@/${SULKA_SERVICEUSER_USERNAME}/g" ${D}${sysconfdir}/sudoers.d/serviceuser

    if [ "${SULKA_SERVICEUSER_ENABLE_SUDO}" -eq 1 ]; then
       sed -i "/^# Defaults:/s/^# //"                     ${D}${sysconfdir}/sudoers.d/serviceuser
       sed -i "/^# ${SULKA_SERVICEUSER_USERNAME}/s/^# //" ${D}${sysconfdir}/sudoers.d/serviceuser
    fi
}
