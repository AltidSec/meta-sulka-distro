FILESEXTRAPATHS:prepend:sulka := "${THISDIR}/linux-yocto:"

SRC_URI:append:sulka = " \
    file://sulka-kmeta;type=kmeta;name=sulka-kmeta;destsuffix=sulka-kmeta \
"

KERNEL_FEATURES:append:sulka = " \
    features/security/security.cfg \
    features/sulka-security/audit.scc \
    features/sulka-security/sulka-cut-attack-surface.scc \
    features/sulka-security/sulka-self-protection.scc \
"

KERNEL_FEATURES:append:sulka-disable-graphics = " \
    features/sulka-security/sulka-cut-graphics.scc \
"
