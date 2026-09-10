FILESEXTRAPATHS:prepend:sulka-harden-mounts := "${THISDIR}/${PN}:"

SRC_URI:append:sulka-harden-mounts = " file://0001-units-Mount-tmp-with-noexec.patch "

do_install:append:sulka-read-only-rootfs () {
    sed -i '/After=systemd-sysusers.service/s/$/ var-volatile-lib.service/' ${D}/${systemd_system_unitdir}/systemd-timesyncd.service
}
