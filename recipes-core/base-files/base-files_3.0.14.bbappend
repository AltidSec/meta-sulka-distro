FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/${PN}:"

ISSUE_MESSAGE = "WARNING: This is a restricted system. Unauthorized access is strictly prohibited. All activities are monitored and recorded."

do_install:append:sulka () {
    sed -i 's/umask.*/umask 027/g' ${D}/${sysconfdir}/profile

    sed -i  "s/@@SULKA_FSTAB_EXTRA_LINES@@/${SULKA_FSTAB_EXTRA_LINES}/g" ${D}${sysconfdir}/fstab

    # Rugix writes during early boot process to the /run, and mounting
    # /run tmpfs later can interfere with these writes. Disable the /run
    # tmpfs mount if Rugix is enabled.
    if ${@bb.utils.contains('DISTRO_FEATURES', 'rugix', 'true', 'false', d)}; then
        sed -i '/^tmpfs\s\+\/run\s/d' ${D}${sysconfdir}/fstab
    fi
}

do_install_basefilesissue:append:sulka () {
    echo "${ISSUE_MESSAGE}" >> ${D}/${sysconfdir}/issue

    echo "${ISSUE_MESSAGE}" > ${D}/${sysconfdir}/issue.net
}
