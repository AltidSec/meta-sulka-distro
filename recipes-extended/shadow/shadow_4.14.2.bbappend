EXTRA_OECONF:append = " --with-yescrypt"

do_install:append () {
    sed -i 's/UMASK.*/UMASK		027/g' ${D}/${sysconfdir}/login.defs
    sed -i 's/ENCRYPT_METHOD SHA512/ENCRYPT_METHOD YESCRYPT/g' ${D}/${sysconfdir}/login.defs
    sed -i 's/#YESCRYPT_COST_FACTOR.*/YESCRYPT_COST_FACTOR 8/g' ${D}/${sysconfdir}/login.defs
}

# Set password minimum and maximum age. There is debate whether this is
# a good practice or not, but it is commonly checked by the audit tools.
#
# NOTE: This will most likely require you to change the password on the
# first login!
do_install:append:sulka-compliancy () {
    sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS	7/g'   ${D}/${sysconfdir}/login.defs
    sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS	365/g' ${D}/${sysconfdir}/login.defs
}
