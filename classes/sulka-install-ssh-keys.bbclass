SULKA_SSH_KEYS_DIR ??= "${TOPDIR}/../auth-keys"

configure_ssh_auth_key() {
    SSH_KEY=${SULKA_SSH_KEYS_DIR}/${SULKA_SERVICEUSER_USERNAME}-auth-key.pub
    mkdir ${IMAGE_ROOTFS}/${SULKA_SERVICEUSER_HOME}/.ssh
    cat ${SSH_KEY} > ${IMAGE_ROOTFS}/${SULKA_SERVICEUSER_HOME}/.ssh/authorized_keys
}

ROOTFS_POSTPROCESS_COMMAND:append = " configure_ssh_auth_key "
