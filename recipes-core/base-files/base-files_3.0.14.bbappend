FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

ISSUE_MESSAGE = "WARNING: This is a restricted system. Unauthorized access is strictly prohibited. All activities are monitored and recorded."

do_install:append () {
    sed -i 's/umask.*/umask 027/g' ${D}/${sysconfdir}/profile

    sed -i  "s/@@SULKA_FSTAB_EXTRA_LINES@@/${SULKA_FSTAB_EXTRA_LINES}/g" ${D}${sysconfdir}/fstab
}

do_install_basefilesissue:append() {
    echo "${ISSUE_MESSAGE}" >> ${D}/${sysconfdir}/issue

    echo "${ISSUE_MESSAGE}" > ${D}/${sysconfdir}/issue.net
}
