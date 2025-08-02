EXTRA_OECONF:append:sulka = " --with-yescrypt"

do_install:append:sulka () {
    sed -i 's/UMASK.*/UMASK		027/g' ${D}/${sysconfdir}/login.defs
    sed -i 's/ENCRYPT_METHOD SHA512/ENCRYPT_METHOD YESCRYPT/g' ${D}/${sysconfdir}/login.defs
    sed -i 's/#YESCRYPT_COST_FACTOR.*/YESCRYPT_COST_FACTOR 8/g' ${D}/${sysconfdir}/login.defs

    # While yescrypt is the default, set a higher amount of rounds for SHA as well
    # in case SHA-512 is used
    sed -i 's/#SHA_CRYPT_MIN_ROUNDS.*/SHA_CRYPT_MIN_ROUNDS 100000/g' ${D}/${sysconfdir}/login.defs
    sed -i 's/#SHA_CRYPT_MAX_ROUNDS.*/SHA_CRYPT_MAX_ROUNDS 100000/g' ${D}/${sysconfdir}/login.defs
}

# Set password minimum and maximum age. There is debate whether this is
# a good practice or not, but it is commonly checked by the audit tools.
#
# NOTE: This will most likely require you to change the password on the
# first login!
do_install:append:sulka-expire-passwords () {
    sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS	7/g'   ${D}/${sysconfdir}/login.defs
    sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS	365/g' ${D}/${sysconfdir}/login.defs
}
