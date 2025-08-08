ROOTFS_POSTPROCESS_COMMAND:append = " \
    serviceuser_home_directory \
    remove_useradd_backup_files \
    harden_cron_directories \
"

serviceuser_home_directory() {
  # Create serviceuser home directory in a separate task to avoid installing user writable
  # files such as .bashrc and .profile
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
  chmod 600 ${IMAGE_ROOTFS}${sysconfdir}/cron.deny
  chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.d
  chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.daily
  chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.hourly
  chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.monthly
  chmod 700 ${IMAGE_ROOTFS}${sysconfdir}/cron.weekly
}
