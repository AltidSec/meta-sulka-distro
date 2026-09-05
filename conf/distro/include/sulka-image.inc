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
QB_DEFAULT_FSTYPE:sulka-read-only-rootfs = "erofs"
# Attempt to add ro kernel boot parameter. There doesn't seem to be one
# standard way of doing this
QB_KERNEL_ROOT:sulka-read-only-rootfs = "/dev/vda ro"
APPEND:append:sulka-read-only-rootfs = " ro "
CMDLINE:append:sulka-read-only-rootfs = " ro "
