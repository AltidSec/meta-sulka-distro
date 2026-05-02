FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/${PN}:"

SRC_URI:append:sulka = " \
    file://55-sulka.rules \
    file://0004-Load-rules-with-auditctl-before-starting-auditd.patch \
"

SRC_URI:append:aarch64 = " file://0003-Remove-arm-aarch64-incompatible-syscalls.patch "

SYSTEMD_SERVICE:auditd = "auditd.service"

# Note that if these are changed, the pkg_postinst_ontarget function needs to be
# revised as it makes changes to 30-stig and 31-privileged rules
AUDIT_RULES_TO_INSTALL = " \
    10-base-config.rules \
    11-loginuid.rules \
    30-stig.rules \
    31-privileged.rules \
    42-injection.rules \
    43-module-load.rules \
    44-installers.rules \
    55-sulka.rules \
    99-finalize.rules \
"

do_install:append:sulka () {
    # Remove the default rules from rules.d to have a clean directory
    rm ${D}/etc/audit/rules.d/audit.rules
    rm ${D}/etc/audit/audit.rules

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        rm ${D}/${systemd_system_unitdir}/audit-rules.service
    fi
    # Install desired rules
    for rule in ${AUDIT_RULES_TO_INSTALL}; do
        if [ -f ${S}/rules/${rule} ]; then
            install -m 0640 ${S}/rules/${rule} ${D}/etc/audit/rules.d/
        elif [ -f ${UNPACKDIR}/${rule} ]; then
            install -m 0640 ${UNPACKDIR}/${rule} ${D}/etc/audit/rules.d/
        else
            bbfatal "Could not find rule ${rule}"
        fi
    done

    # Finalize rule is usually commented out, uncomment it
    if [ -f ${D}/etc/audit/rules.d/99-finalize.rules ]; then
        sed -i '/^#.*-e 2/s/^#//' ${D}/etc/audit/rules.d/99-finalize.rules
    fi
}
