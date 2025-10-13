FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/${PN}:"

SRC_URI:append:sulka = " \
    file://55-sulka.rules \
    file://0002-Run-audit-rules.service-after-run-postinsts.service.patch \
"

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
    rm ${D}/etc/audit/rules.d/audit.rules

    for rule in ${AUDIT_RULES_TO_INSTALL}; do
        if [ -f ${S}/rules/${rule} ]; then
            install -m 0640 ${S}/rules/${rule} ${D}/etc/audit/rules.d/
        elif [ -f ${WORKDIR}/${rule} ]; then
            install -m 0640 ${WORKDIR}/${rule} ${D}/etc/audit/rules.d/
        else
            bbfatal "Could not find rule ${rule}"
        fi
    done
}

pkg_postinst_ontarget:${PN}:sulka () {
    # Add all the setuid binaries to 31-privileged.rules. Note that
    # we do not add additional privileged binaries that could be
    # found with filecap search as filecap would be additional
    # dependency
    find /bin -type f -perm -04000 2>/dev/null | awk '{ printf "-a always,exit -F arch=b32 -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", $1 }' > /etc/audit/rules.d/31-privileged.rules
    find /sbin -type f -perm -04000 2>/dev/null | awk '{ printf "-a always,exit -F arch=b32 -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", $1 }' >> /etc/audit/rules.d/31-privileged.rules
    find /usr/bin -type f -perm -04000 2>/dev/null | awk '{ printf "-a always,exit -F arch=b32 -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", $1 }' >> /etc/audit/rules.d/31-privileged.rules
    find /usr/sbin -type f -perm -04000 2>/dev/null | awk '{ printf "-a always,exit -F arch=b32 -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", $1 }' >> /etc/audit/rules.d/31-privileged.rules

    find /bin -type f -perm -04000 2>/dev/null | awk '{ printf "-a always,exit -F arch=b64 -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", $1 }' >> /etc/audit/rules.d/31-privileged.rules
    find /sbin -type f -perm -04000 2>/dev/null | awk '{ printf "-a always,exit -F arch=b64 -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", $1 }' >> /etc/audit/rules.d/31-privileged.rules
    find /usr/bin -type f -perm -04000 2>/dev/null | awk '{ printf "-a always,exit -F arch=b64 -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", $1 }' >> /etc/audit/rules.d/31-privileged.rules
    find /usr/sbin -type f -perm -04000 2>/dev/null | awk '{ printf "-a always,exit -F arch=b64 -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", $1 }' >> /etc/audit/rules.d/31-privileged.rules

    # NetworkManager and selinux directories don't always exist, so
    # comment them out if they are not in the system
    [ ! -d "/etc/NetworkManager" ] && sed -i 's/^.*\/etc\/NetworkManager.*$/# &/' /etc/audit/rules.d/30-stig.rules
    [ ! -d "/etc/selinux" ]        && sed -i 's/^.*\/etc\/selinux.*$/# &/'        /etc/audit/rules.d/30-stig.rules
}
