ROOTFS_POSTPROCESS_COMMAND:append = " remove_useradd_backup_files "

remove_useradd_backup_files () {
  rm ${IMAGE_ROOTFS}/etc/group-
  rm ${IMAGE_ROOTFS}/etc/gshadow-
  rm ${IMAGE_ROOTFS}/etc/passwd-
  rm ${IMAGE_ROOTFS}/etc/shadow-
  rm ${IMAGE_ROOTFS}/etc/subgid-
  rm ${IMAGE_ROOTFS}/etc/subuid-
}
