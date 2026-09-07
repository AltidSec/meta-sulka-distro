# This should be identical to the main recipe, except that shell has been changed to nologin
USERADD_PARAM:${PN}-sshd:sulka-hardening = "--system --no-create-home --home-dir /var/run/sshd --shell /sbin/nologin --user-group sshd"

# Bulk of these values originate from meta-security/meta-hardening
do_install:append:sulka-hardening () {
    sed -i -e 's:#AllowTcpForwarding yes:AllowTcpForwarding no:' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i -e 's:ClientAliveCountMax 4:ClientAliveCountMax 2:' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i -e 's:#LogLevel INFO:LogLevel VERBOSE:' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i -e 's:#MaxSessions.*:MaxSessions 2:' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i -e 's:#TCPKeepAlive yes:TCPKeepAlive no:' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i -e 's:#AllowAgentForwarding yes:AllowAgentForwarding no:' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i -e 's:#PermitRootLogin.*:PermitRootLogin no:' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i -e 's:#PasswordAuthentication.*:PasswordAuthentication no:' ${D}${sysconfdir}/ssh/sshd_config*
    sed -i -e 's:#MaxAuthTries.*:MaxAuthTries 3:' ${D}${sysconfdir}/ssh/sshd_config*

    sed -i -e 's:#Banner.*:Banner /etc/issue.net:' ${D}${sysconfdir}/ssh/sshd_config*

    if [ "${SULKA_SSH_PORT}" -ne "22" ]; then
        sed -i -e "s:#Port.*:Port ${SULKA_SSH_PORT}:" ${D}${sysconfdir}/ssh/sshd_config*
    fi
    chmod 600 ${D}${sysconfdir}/ssh/sshd_config
    chmod 600 ${D}${sysconfdir}/ssh/sshd_config_readonly
}
