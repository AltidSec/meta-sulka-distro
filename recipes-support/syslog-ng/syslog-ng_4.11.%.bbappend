FILESEXTRAPATHS:prepend:sulka-hardening := "${THISDIR}/files:"

SRC_URI:append:sulka-hardening = " file://0010-syslog-ng-Disable-xconsole-logging.patch;patchdir=${UNPACKDIR} "

RDEPENDS:${PN}:remove:sulka-hardening = "gawk"

do_install:append:sulka-hardening() {
    # Remove files using awk:
    # syslog debug bundle generator
    rm ${D}/${sbindir}/syslog-ng-debun
    # syslog configuration conversion plugin
    rm -rf ${D}/${datadir}/syslog-ng/include/scl/syslogconf
}
