# Aim for the following default feature set: acl ipv4 ipv6 integrity ldconfig pam seccomp security xattr
DISTRO_FEATURES:append = " pam integrity security"
DISTRO_FEATURES_OPTED_OUT ?= " \
    3g \
    alsa \
    bluetooth \
    debuginfod \
    ext2 \
    gobject-introspection-data \
    multiarch \
    nfc \
    nfs \
    opengl \
    pci \
    ptest \
    pulseaudio \
    vfat \
    vulkan \
    wayland \
    wifi \
    x11 \
    zeroconf \
"

IMAGE_FEATURES:remove = "splash"

require conf/distro/include/rust_security_flags.inc

SULKA_DEFAULT_EXTRA_RDEPENDS ?= "packagegroup-core-boot packagegroup-sulka packagegroup-sulka-netfilter-modules"
SULKA_DEFAULT_EXTRA_RRECOMMENDS ?= ""
DISTRO_EXTRA_RDEPENDS += " ${SULKA_DEFAULT_EXTRA_RDEPENDS}"
DISTRO_EXTRA_RRECOMMENDS += " ${SULKA_DEFAULT_EXTRA_RRECOMMENDS}"

VIRTUAL-RUNTIME_base-utils-syslog ?= "syslog-ng"

SULKA_ENABLE_MONITORING ??= "0"
SULKA_ENABLE_MONITORING:sulka-compliancy = "1"
SULKA_DEFAULT_EXTRA_RDEPENDS:append = "${@" packagegroup-sulka-monitoring " if d.getVar('SULKA_ENABLE_MONITORING') == "1" else ""}"

INHERIT += "create-spdx"

IMAGE_CLASSES:append = " sbom-cve-check"
SRCREV:pn-sbom-cve-check-update-nvd-native = "${AUTOREV}"
SRCREV:pn-sbom-cve-check-update-cvelist-native = "${AUTOREV}"
SPDX_INCLUDE_VEX = "all"
SPDX_INCLUDE_COMPILED_SOURCES:pn-linux-yocto = "1"
include conf/distro/include/cve-extra-exclusions.inc

# Enable the read-only rootfs support
SULKA_ENABLE_READ_ONLY_ROOTFS ??= "1"
OVERRIDES:append = "${@":sulka-read-only-rootfs" if d.getVar('SULKA_ENABLE_READ_ONLY_ROOTFS') == "1" else ""}"
EXTRA_IMAGE_FEATURES:append:sulka-read-only-rootfs = " read-only-rootfs"
IMAGE_FSTYPES:append:sulka-read-only-rootfs = " erofs"
# Attempt to add ro kernel boot parameter. There doesn't seem to be one
# standard way of doing this
QB_KERNEL_ROOT:sulka-read-only-rootfs = "/dev/vda ro"
APPEND:append:sulka-read-only-rootfs = " ro "
CMDLINE:append:sulka-read-only-rootfs = " ro "

# The image type of the rootfs, for example for writing it into a disk image
SULKA_ROOTFS_IMAGE_TYPE ??= "ext4"
SULKA_ROOTFS_IMAGE_TYPE:sulka-read-only-rootfs = "erofs"
QB_DEFAULT_FSTYPE:sulka-read-only-rootfs = "${SULKA_ROOTFS_IMAGE_TYPE}"

# Verified boot from U-Boot onwards. U-Boot boots only FIT images whose
# configuration is signed with UBOOT_SIGN_KEYNAME from UBOOT_SIGN_KEYDIR. The
# FIT image contains the kernel, the device tree and the initramfs. The root of
# trust that verifies U-Boot itself is platform specific and not provided.
# Disabled by default, as this feature is quite hardware and setup specific.
# qemuarm64 can be used as an example reference of this.
SULKA_ENABLE_VERIFIED_BOOT ??= "0"
OVERRIDES:append = "${@":sulka-verified-boot" if d.getVar('SULKA_ENABLE_VERIFIED_BOOT') == "1" else ""}"
UBOOT_SIGN_ENABLE:sulka-verified-boot = "1"
FIT_SIGN_INDIVIDUAL:sulka-verified-boot = "0"
FIT_HASH_ALG:sulka-verified-boot = "sha256"
FIT_SIGN_ALG:sulka-verified-boot = "rsa4096"
FIT_SIGN_NUMBITS:sulka-verified-boot = "4096"
KERNEL_CLASSES:append:sulka-verified-boot = " kernel-fit-extra-artifacts"
INHERIT += "${@"sulka-verified-boot" if d.getVar('SULKA_ENABLE_VERIFIED_BOOT') == "1" else ""}"
# The recipe that builds the FIT image of the kernel. Default to empty, as it
# should be defined in the same place as where the verified boot is enabled.
SULKA_FIT_IMAGE_RECIPE ??= ""
EXTRA_IMAGEDEPENDS:append:sulka-verified-boot = " ${SULKA_FIT_IMAGE_RECIPE} virtual/bootloader"
# Rebuild disk images that contain the FIT image whenever it changes
do_image_wic[depends] += "${@'%s:do_deploy' % d.getVar('SULKA_FIT_IMAGE_RECIPE') if d.getVar('SULKA_ENABLE_VERIFIED_BOOT') == '1' else ''}"

# Internal. The features that require the initramfs add themselves here,
# which enables the initramfs and selects its modules in
# sulka-image-initramfs. Enable the features instead of setting this.
SULKA_FEATURES_REQUIRING_INITRAMFS = ""

# Build sulka-image-initramfs. With verified boot it is added to the FIT
# image, otherwise it is bundled into the kernel image. Enabled by default
# only when a feature needs it. Set to "1" to use the initramfs without such
# a feature.
SULKA_ENABLE_INITRAMFS ??= "${@'1' if d.getVar('SULKA_FEATURES_REQUIRING_INITRAMFS').split() else '0'}"
OVERRIDES:append = "${@":sulka-initramfs" if d.getVar('SULKA_ENABLE_INITRAMFS') == "1" else ""}"
INITRAMFS_IMAGE:sulka-initramfs = "sulka-image-initramfs"
INITRAMFS_IMAGE_BUNDLE:sulka-initramfs = "${@'0' if d.getVar('SULKA_ENABLE_VERIFIED_BOOT') == '1' else '1'}"

# Protect the read-only rootfs with dm-verity. The hash tree is appended
# to the rootfs image and the root hash is stored in the initramfs. With
# verified boot the initramfs is part of the signed FIT image. Without it
# the initramfs is bundled into the kernel image, and the root hash is only
# as trustworthy as the unverified kernel image that carries it. Enabled by
# default whenever the rootfs is read-only.
SULKA_ENABLE_DM_VERITY ??= "${SULKA_ENABLE_READ_ONLY_ROOTFS}"
OVERRIDES:append = "${@":sulka-dm-verity" if d.getVar('SULKA_ENABLE_DM_VERITY') == "1" else ""}"
SULKA_FEATURES_REQUIRING_INITRAMFS:append:sulka-dm-verity = " dm-verity"
IMAGE_CLASSES:append:sulka-dm-verity = " dm-verity-img"
DM_VERITY_IMAGE_TYPE ?= "erofs"
DM_VERITY_IMAGE_DATA_BLOCK_SIZE ?= "4096"
SULKA_ROOTFS_IMAGE_TYPE:sulka-dm-verity = "${DM_VERITY_IMAGE_TYPE}.verity"
# The LUKS2 SSH token plugin fetches keys over the network and links libssh,
# which pulls libgcrypt, libcap and libpam into the initramfs. Disable the
# plugin by default
PACKAGECONFIG:remove:pn-cryptsetup = "ssh-token"
