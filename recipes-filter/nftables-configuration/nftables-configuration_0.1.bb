SUMMARY = "nftables configuration "
DESCRIPTION = "Configuration script for the nftables to load ruleset at boot"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://nftables-allow-established-lo-outgoing.conf \
    file://nftables-allow-established-lo-ssh-icmp-outgoing.conf \
    file://nftables-drop-everything.conf \
    file://nftables-configuration.sh \
    file://nftables-configuration.service \
"

RDEPENDS:${PN} = "nftables"

inherit update-rc.d systemd

do_configure[noexec] = "1"
do_compile[noexec] = "1"

SULKA_NFTABLES_CONF ??= "nftables-drop-everything.conf"

do_install() {
    install -d ${D}${sysconfdir}/
    install -d ${D}/${sysconfdir}/init.d

    install -m 644 ${WORKDIR}/${SULKA_NFTABLES_CONF} ${D}${sysconfdir}/nftables.conf

    if ${@bb.utils.contains('DISTRO_FEATURES','sysvinit','true','false',d)}; then
        install -m 755 ${WORKDIR}/nftables-configuration.sh ${D}/${sysconfdir}/init.d/nftables-configuration
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}/${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/nftables-configuration.service ${D}${systemd_unitdir}/system
    fi
}

INITSCRIPT_NAME = "nftables-configuration"
INITSCRIPT_PARAMS = "start 30 S . stop 99 0 1 6 ."

SYSTEMD_SERVICE:${PN} = "nftables-configuration.service"
