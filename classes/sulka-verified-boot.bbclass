# Rebuild the FIT image and U-Boot when the FIT signing key changes.
#
# The signing tasks depend only on the key directory and name, not on the key.
# After a new key is generated in the same place, one of them could be rebuilt
# with the new key while the other is taken from the shared state cache with
# the old one, and U-Boot would refuse to boot the FIT image. Make the relevant
# tasks depend on the certificate hash, which contains the public key of the
# key pair.

python () {
    if bb.data.inherits_class('kernel-fit-image', d):
        task = 'do_compile'
        keydir = d.getVar('FIT_KERNEL_SIGN_KEYDIR')
        keyname = d.getVar('FIT_KERNEL_SIGN_KEYNAME')
    elif bb.data.inherits_class('uboot-sign', d):
        task = 'do_uboot_assemble_fitimage'
        keydir = d.getVar('UBOOT_SIGN_KEYDIR')
        keyname = d.getVar('UBOOT_SIGN_KEYNAME')
    else:
        return

    if keydir and keyname:
        d.appendVarFlag(task, 'file-checksums', ' %s/%s.crt:True' % (keydir, keyname))
}
