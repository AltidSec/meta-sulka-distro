FILESEXTRAPATHS:prepend := "${THISDIR}/linux-yocto:"

SRC_URI:append = " \
    file://sulka-kmeta;type=kmeta;name=sulka-kmeta;destsuffix=sulka-kmeta \
"

KERNEL_FEATURES:append = " \
    features/security/security.cfg \
    features/sulka-security/sulka-cut-attack-surface.scc \
    features/sulka-security/sulka-self-protection.scc \
"
