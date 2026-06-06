do_install:append:sulka-read-only-rootfs () {
    sed -i '/After=systemd-sysusers.service/s/$/ var-volatile-lib.service/' ${D}/${systemd_system_unitdir}/systemd-timesyncd.service
}
