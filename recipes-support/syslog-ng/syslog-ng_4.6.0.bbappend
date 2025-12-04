RDEPENDS:${PN}:remove = "gawk"

do_install:append() {
    # Remove files using awk:
    # syslog debug bundle generator
    rm ${D}/${sbindir}/syslog-ng-debun
    # syslog configuration conversion plugin
    rm -rf ${D}/${datadir}/syslog-ng/include/scl/syslogconf
}
