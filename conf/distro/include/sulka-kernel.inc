PREFERRED_VERSION_linux-yocto ?= "6.6%"
PREFERRED_VERSION_linux-yocto-rt ?= "6.6%"

KERNEL_EXTRA_FEATURES:append = " features/nf_tables/nf_tables.scc"

KERNEL_MODULE_AUTOLOAD:append = " \
    nf_log_syslog \
    nft_ct \
    nft_limit \
    nft_log \
"

# Option to enable the kernel hardening. Enabled by default, this feature enables plenty of
# kernel hardening and security measures. The kernel metadata is in the meta-sulka-kernel
# meta-layer. Graphics can also be enabled or disabled to cut the kernel attack surface and
# size.
SULKA_HARDEN_KERNEL ??= "1"
OVERRIDES:append = "${@":sulka-harden-kernel" if d.getVar('SULKA_HARDEN_KERNEL') == "1" else ""}"

SULKA_DISABLE_GRAPHICS ??= "1"
OVERRIDES:append = "${@":sulka-disable-graphics" if d.getVar('SULKA_DISABLE_GRAPHICS') == "1" else ""}"
USE_VT:sulka-disable-graphics = "0"

SULKA_DISABLE_KERNEL_MODULES ??= "0"
SULKA_DISABLE_KERNEL_MODULES:sulka-compliancy = "1"
OVERRIDES:append = "${@":sulka-disable-kernel-modules" if d.getVar('SULKA_DISABLE_KERNEL_MODULES') == "1" else ""}"
DISTRO_EXTRA_RDEPENDS:remove:sulka-disable-kernel-modules = "packagegroup-sulka-netfilter-modules"

# Option to enable module signing.
SULKA_ENABLE_MODULE_SIGNING ??= "1"
OVERRIDES:append = "${@":sulka-enable-module-signing" if d.getVar('SULKA_ENABLE_MODULE_SIGNING') == "1" else ""}"
DISTRO_FEATURES:append:sulka-enable-module-signing = " ima modsign "
