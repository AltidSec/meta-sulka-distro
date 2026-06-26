SUMMARY = "Sulka device hardening packages"
DESCRIPTION = "Packages that are used to harden the system"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGES += "${PN}-monitoring ${PN}-netfilter-modules"

# These are the basic packages used for system hardening. These should
# always be installed, with possible exceptions of cronie and
# dpkg-start-stop.
RDEPENDS:${PN} = "\
    dpkg-start-stop \
    nftables \
    nftables-configuration \
    passwdqc \
    sudo \
"

# These are monitoring, auditing, and intrusion detection packages. They
# requires a bit of extra work to get the most of them (non-volatile
# logging partition and remote logging), and the logs they produce also
# eat up some disk space. However, they can still provide useful insights
# as-is, assuming you have enough disk space for the logs. It is
# recommended to go throughthese, understand what they do, and possibly
# configure or remove them. These are installed by default.
RDEPENDS:${PN}-monitoring = "\
    auditd \
    sysstat \
"

RDEPENDS:${PN}-netfilter-modules = "\
    kernel-module-nf-log-syslog \
    kernel-module-nft-ct \
    kernel-module-nft-limit \
    kernel-module-nft-log \
"
