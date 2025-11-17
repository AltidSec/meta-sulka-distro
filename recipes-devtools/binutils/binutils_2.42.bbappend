do_install:append () {
    # Make the assembler usable by root only
    chmod 700 ${D}/${bindir}/${TARGET_SYS}-as
}
