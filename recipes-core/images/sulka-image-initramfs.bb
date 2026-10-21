# Based on core-image-initramfs-boot from openembedded-core
SUMMARY = "Minimal initramfs for Sulka"
DESCRIPTION = "Small initramfs based on initramfs-framework that sets up and \
mounts the rootfs. The modules are selected by \
SULKA_FEATURES_REQUIRING_INITRAMFS. With dm-verity it sets up the verified \
rootfs, otherwise it mounts root= directly."
LICENSE = "MIT"

INITRAMFS_SCRIPTS ?= "initramfs-framework-base \
    ${@bb.utils.contains('SULKA_FEATURES_REQUIRING_INITRAMFS', 'dm-verity', 'initramfs-module-dmverity', 'initramfs-module-rootfs', d)} \
"

# Additional packages, for example initramfs-module-udev and base-passwd
# when the root device is given as root=PARTUUID=, UUID= or LABEL=
SULKA_INITRAMFS_EXTRA_INSTALL ??= ""

PACKAGE_INSTALL = "${INITRAMFS_SCRIPTS} ${VIRTUAL-RUNTIME_base-utils} \
    ${@bb.utils.contains('SULKA_FEATURES_REQUIRING_INITRAMFS', 'dm-verity', 'cryptsetup', '', d)} \
    ${SULKA_INITRAMFS_EXTRA_INSTALL} \
"

# Ensure the initramfs only contains the bare minimum
IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""
# Install only what is listed above
NO_RECOMMENDATIONS = "1"

PACKAGE_EXCLUDE = "kernel-image-*"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_NAME_SUFFIX ?= ""
IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

inherit image

# The distro adds the rootfs and disk image types, which the initramfs does
# not need
IMAGE_FSTYPES:remove = "erofs ${DM_VERITY_IMAGE_TYPE}.verity wic"
# Verified boot makes every image depend on the FIT image and U-Boot. The FIT
# image contains this initramfs, so depending on it would be circular, and the
# initramfs doesn't need the bootloader dependency either.
EXTRA_IMAGEDEPENDS:remove = "${SULKA_FIT_IMAGE_RECIPE} virtual/bootloader"

# The initramfs has no service user, see EXTRA_USERS_PARAMS below
ROOTFS_POSTPROCESS_COMMAND:remove = "serviceuser_home_directory configure_ssh_auth_key"

# Install the dm-verity root hash and parameters of DM_VERITY_IMAGE
deploy_verity_hash() {
    install -D -m 0644 \
        ${STAGING_VERITY_DIR}/${DM_VERITY_IMAGE}.${DM_VERITY_IMAGE_TYPE}.verity.env \
        ${IMAGE_ROOTFS}${datadir}/misc/dm-verity.env
}
IMAGE_PREPROCESS_COMMAND:append = "${@bb.utils.contains('SULKA_FEATURES_REQUIRING_INITRAMFS', 'dm-verity', ' deploy_verity_hash', '', d)}"

python __anonymous() {
    # The distro wide EXTRA_USERS_PARAMS create the service user, which does
    # not belong in the initramfs and would pull in shadow and PAM
    d.setVar('EXTRA_USERS_PARAMS', '')

    if not bb.utils.contains('SULKA_FEATURES_REQUIRING_INITRAMFS', 'dm-verity', True, False, d):
        return

    verity_image = d.getVar('DM_VERITY_IMAGE')
    verity_type = d.getVar('DM_VERITY_IMAGE_TYPE')
    d.appendVarFlag('do_image', 'depends', ' %s:do_image_%s' % (verity_image, verity_type.replace('-', '_')))
    # veritysetup uses a random salt, so the root hash changes on every
    # rootfs image build even when the task hash does not
    d.setVarFlag('do_image', 'nostamp', '1')
}
