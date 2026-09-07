# Sulka hardening, entry point.
#
# Requiring this file applies the full Sulka hardening. It sets no distro
# identity variables of its own, so it can be required from any distro
# configuration:
#
#     require conf/distro/include/sulka-hardening.inc

OVERRIDES:append = ":sulka-hardening"

# Build time guards. Fails the build on configurations that undo the hardening,
# such as debug-tweaks in IMAGE_FEATURES or a module signing setup with no keys.
INHERIT += "variable-check"

# Global modes:

# Enable development mode. This option disables some security features and configurations that
# may be problematic during system development and debugging phases. It is recommended to keep
# this disabled for the production systems, but might be useful for other purposes
SULKA_DEVELOPMENT_MODE ??= "0"
OVERRIDES:append = "${@":sulka-development-mode" if d.getVar('SULKA_DEVELOPMENT_MODE') == "1" else ""}"

# Extra compliancy enables features that may not be the best fit for the
# embedded systems or that are outdated security advice but are still
# commonly required by audit tools and processes
SULKA_EXTRA_COMPLIANCY ??= "0"
OVERRIDES:append = "${@":sulka-compliancy" if d.getVar('SULKA_EXTRA_COMPLIANCY') == "1" else ""}"

# Grouped Sulka hardening:

# What the image is made of: distro features, package selection, the software
# bill of materials, and the read-only root file system.
require conf/distro/include/sulka-image.inc

# Userspace related hardening: users, SSH, SELinux, and mounts
require conf/distro/include/sulka-userspace.inc

# Kernel configuration and the options that select the hardening fragments.
# Requires meta-sulka-kernel to be actually useful
require conf/distro/include/sulka-kernel.inc

# Sulka's policy on GPLv3 components.
require conf/distro/include/sulka-gplv3.inc
