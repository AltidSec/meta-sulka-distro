ROOTFS_POSTPROCESS_COMMAND:append = " \
    serviceuser_home_directory \
    remove_useradd_backup_files \
    harden_cron_directories \
    finalize_audit_rules \
"

serviceuser_home_directory() {
  # Create serviceuser home directory in a separate task to avoid installing user writable
  # files such as .bashrc and .profile
  if [ -z "${SULKA_SERVICEUSER_PASSWORD}" ]; then
    return
  fi

  install -d ${IMAGE_ROOTFS}/${SULKA_SERVICEUSER_HOME}
  chown root:${SULKA_SERVICEUSER_USERNAME} ${IMAGE_ROOTFS}/${SULKA_SERVICEUSER_HOME}
  chmod 750 ${IMAGE_ROOTFS}/${SULKA_SERVICEUSER_HOME}
}

remove_useradd_backup_files () {
  rm -f ${IMAGE_ROOTFS}/etc/group-
  rm -f ${IMAGE_ROOTFS}/etc/gshadow-
  rm -f ${IMAGE_ROOTFS}/etc/passwd-
  rm -f ${IMAGE_ROOTFS}/etc/shadow-
  rm -f ${IMAGE_ROOTFS}/etc/subgid-
  rm -f ${IMAGE_ROOTFS}/etc/subuid-
}

harden_cron_directories () {
  # Set cron files to be readable only by root
  [ -f ${IMAGE_ROOTFS}${sysconfdir}/cron.deny ] && chmod 600 ${IMAGE_ROOTFS}${sysconfdir}/cron.deny || true
  [ -d ${IMAGE_ROOTFS}${sysconfdir}/cron.d ] && chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.d || true
  [ -d ${IMAGE_ROOTFS}${sysconfdir}/cron.daily ] && chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.daily || true
  [ -d ${IMAGE_ROOTFS}${sysconfdir}/cron.hourly ] && chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.hourly || true
  [ -d ${IMAGE_ROOTFS}${sysconfdir}/cron.monthly ] && chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.monthly || true
  [ -d ${IMAGE_ROOTFS}${sysconfdir}/cron.weekly ] && chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.weekly || true
}

finalize_audit_rules () {
    # Generate the rule file for privileged binaries
    if [ -d ${IMAGE_ROOTFS}/etc/audit/rules.d ]; then
        # Create/clear the rules file
        > ${IMAGE_ROOTFS}/etc/audit/rules.d/31-privileged.rules

        # Iterate through directories and architectures
        for dir in /bin /sbin /usr/bin /usr/sbin; do
            for arch in b32 b64; do
                find ${IMAGE_ROOTFS}${dir} -type f -perm -04000 2>/dev/null | \
                sed "s|^${IMAGE_ROOTFS}||" | \
                awk -v arch="${arch}" '{ printf "-a always,exit -F arch=%s -F path=%s -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged\n", arch, $1 }'
            done
        done >> ${IMAGE_ROOTFS}/etc/audit/rules.d/31-privileged.rules
    fi

    # NetworkManager and selinux directories don't always exist, so
    # comment them out if they are not in the system
    if [ -f ${IMAGE_ROOTFS}/etc/audit/rules.d/30-stig.rules ]; then
        [ ! -d "${IMAGE_ROOTFS}/etc/NetworkManager" ] && sed -i 's/^.*\/etc\/NetworkManager.*$/# &/' ${IMAGE_ROOTFS}/etc/audit/rules.d/30-stig.rules || true
        [ ! -d "${IMAGE_ROOTFS}/etc/selinux" ]        && sed -i 's/^.*\/etc\/selinux.*$/# &/'        ${IMAGE_ROOTFS}/etc/audit/rules.d/30-stig.rules || true
    fi

    # Generate the audit.rules file if augenrules binary exists
    if [ -x ${IMAGE_ROOTFS}/sbin/augenrules ]; then
        for rules in $(ls -1v ${IMAGE_ROOTFS}/etc/audit/rules.d | grep "\.rules$") ; do
                cat ${IMAGE_ROOTFS}/etc/audit/rules.d/${rules}
        done | awk '
        BEGIN   {
                minus_e = "";
                minus_D = "";
                minus_f = "";
                minus_b = "";
                rest = 0;
        } {
                sub(/\r$/, "");
                if (length($0) < 1) { next; }
                if (match($0, "^\\s*#")) { next; }
                if (match($0, "^\\s*-e")) { minus_e = $0; next; }
                if (match($0, "^\\s*-D\\s*$")) { minus_D = $0; next; }
                if (match($0, "^\\s*-f")) { minus_f = $0; next; }
                if (match($0, "^\\s*-b")) { minus_b = $0; next; }
                rules[rest++] = $0;
        }
        END     {
                printf "%s\n%s\n%s\n", minus_D, minus_b, minus_f;
                for (i = 0; i < rest; i++) { printf "%s\n", rules[i]; }
                printf "%s\n", minus_e;
        }' >> ${IMAGE_ROOTFS}/etc/audit/audit.rules
        chmod 0640 ${IMAGE_ROOTFS}/etc/audit/audit.rules
        chown root:root ${IMAGE_ROOTFS}/etc/audit/audit.rules
    fi
}
