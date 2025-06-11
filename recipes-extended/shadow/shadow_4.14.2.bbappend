do_install:append () {
    sed -i 's/UMASK.*/UMASK		027/g' ${D}/${sysconfdir}/login.defs
}
