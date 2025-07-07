SUMMARY = "Sulka device hardening packages"
DESCRIPTION = "Packages that are used to harden the system"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGES += "${PN}-netfilter-modules"

RDEPENDS:${PN} = "\
    auditd \
    dpkg-start-stop \
    nftables \
    nftables-configuration \
    sudo \
"

RDEPENDS:${PN}-netfilter-modules = "\
    kernel-module-nf-log-syslog \
    kernel-module-nft-ct \
    kernel-module-nft-limit \
    kernel-module-nft-log \
"




