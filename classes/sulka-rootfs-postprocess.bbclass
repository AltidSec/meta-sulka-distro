ROOTFS_POSTPROCESS_COMMAND:append = " remove_useradd_backup_files "

remove_useradd_backup_files () {
  rm -f ${IMAGE_ROOTFS}/etc/group-
  rm -f ${IMAGE_ROOTFS}/etc/gshadow-
  rm -f ${IMAGE_ROOTFS}/etc/passwd-
  rm -f ${IMAGE_ROOTFS}/etc/shadow-
  rm -f ${IMAGE_ROOTFS}/etc/subgid-
  rm -f ${IMAGE_ROOTFS}/etc/subuid-
}
