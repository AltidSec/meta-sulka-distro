SULKA_DEFAULT_DISTRO_FEATURES ?= "acl ipv4 ipv6 xattr seccomp ldconfig pam security integrity"
SULKA_DEFAULT_EXTRA_RDEPENDS ?= "packagegroup-core-boot packagegroup-sulka packagegroup-sulka-netfilter-modules"
SULKA_DEFAULT_EXTRA_RRECOMMENDS ?= ""

DISTRO_FEATURES ?= "${SULKA_DEFAULT_DISTRO_FEATURES}"
DISTRO_FEATURES_BACKFILL_CONSIDERED ?= "pulseaudio gobject-introspection-data"
DISTRO_EXTRA_RDEPENDS += " ${SULKA_DEFAULT_EXTRA_RDEPENDS}"
DISTRO_EXTRA_RRECOMMENDS += " ${SULKA_DEFAULT_EXTRA_RRECOMMENDS}"

VIRTUAL-RUNTIME_base-utils-syslog ?= "syslog-ng"

IMAGE_FEATURES:remove = "splash"

require conf/distro/include/security_flags.inc
require conf/distro/include/rust_security_flags.inc

INHERIT += "cve-check create-spdx"
include conf/distro/include/cve-extra-exclusions.inc

SULKA_ENABLE_MONITORING ??= "0"
SULKA_ENABLE_MONITORING:sulka-compliancy = "1"
SULKA_DEFAULT_EXTRA_RDEPENDS:append = "${@" packagegroup-sulka-monitoring " if d.getVar('SULKA_ENABLE_MONITORING') == "1" else ""}"

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
