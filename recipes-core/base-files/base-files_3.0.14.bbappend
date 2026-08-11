ISSUE_MESSAGE = "WARNING: This is a restricted system. Unauthorized access is strictly prohibited. All activities are monitored and recorded."

# Harden the mount options on base-files' stock fstab:
# hidepid on /proc and nodev,nosuid,noexec
# on the volatile tmpfs mounts.
# Note: noexec in /run and in the volatile mounts may cause
# problems with legit scripts, adjust if necessary.
do_install:append:sulka-harden-mounts () {
    sed -i \
        -e '/\s\/proc\s/          s/\bdefaults\b/hidepid=2/' \
        -e '/\s\/run\s/           s/\bnodev,nosuid,strictatime\b/nodev,nosuid,noexec,strictatime/' \
        -e '/\s\/var\/volatile\s/ s/\bdefaults\b/nodev,nosuid,noexec/' \
        ${D}${sysconfdir}/fstab

    # sed silently no-ops if the expected fstab lines are missing, so
    # verify the hardening actually landed and fail the build otherwise.
    # Set SULKA_HARDEN_MOUNTS = "0" if you ship your own fstab and this fails.
    grep -Eq '^proc[[:space:]].*\bhidepid=2\b' ${D}${sysconfdir}/fstab || \
        bbfatal "SULKA_HARDEN_MOUNTS: hidepid=2 not set on /proc in ${sysconfdir}/fstab"
    grep -Eq '^tmpfs[[:space:]]+/run[[:space:]].*\bnoexec\b' ${D}${sysconfdir}/fstab || \
        bbfatal "SULKA_HARDEN_MOUNTS: noexec not set on /run in ${sysconfdir}/fstab"
    grep -Eq '^tmpfs[[:space:]]+/var/volatile[[:space:]].*\bnodev,nosuid,noexec\b' ${D}${sysconfdir}/fstab || \
        bbfatal "SULKA_HARDEN_MOUNTS: /var/volatile not hardened in ${sysconfdir}/fstab"
}

do_install:append:sulka () {
    sed -i 's/umask.*/umask 027/g' ${D}/${sysconfdir}/profile

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
