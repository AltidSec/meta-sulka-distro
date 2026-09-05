# kbd-keymaps-pine is GPLv3 licensed
PACKAGE_EXCLUDE:append = " kbd-keymaps-pine"
# readline is GPLv3 licensed, so configure packages not to use it
PACKAGECONFIG:remove:pn-gawk = "readline"
PACKAGECONFIG:remove:pn-nftables = "readline"
# Use uutils-coreutils as it has more permissive license than coreutils
PREFERRED_PROVIDER_coreutils = "uutils-coreutils"
# QEMU machine has GNU tar as dependency, remove it
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:remove = "tar"
