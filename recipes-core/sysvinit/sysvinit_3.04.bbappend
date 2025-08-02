do_install:append:sulka () {
    sed -i '/export PSPLASH_FIFO_DIR/a\umask 027' ${D}/${sysconfdir}/init.d/rc
    sed -i 's/umask.*/umask 027/g' ${D}/${sysconfdir}/init.d/rcS
}
