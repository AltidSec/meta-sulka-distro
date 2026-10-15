# Check for insecure IMAGE_FEATURES
addhandler check_insecure_image_features
check_insecure_image_features[eventmask] = "bb.event.ConfigParsed bb.event.MultiConfigParsed"

python check_insecure_image_features () {
    insecure_features = ["debug-tweaks", "empty-root-password", "allow-empty-password", "allow-root-login", "serial-autologin-root"]
    image_features = (d.getVar('IMAGE_FEATURES') or '').split()

    found_insecure = [f for f in insecure_features if f in image_features]

    if found_insecure:
        bb.fatal("ERROR: Insecure IMAGE_FEATURES detected: %s\n"
                 "These features are not allowed in this distribution.\n"
                 "Disable these by adding IMAGE_FEATURES:remove = \"<insecure features>\" to your build config. " % ', '.join(found_insecure))

    if "ssh-server-dropbear" in image_features:
        bb.warn("ssh-server-dropbear is in the IMAGE_FEATURES.\n"
                "The configuration of the dropbear is not hardened.\n"
                "Please use ssh-server-openssh instead.")

    if d.getVar('SULKA_DEVELOPMENT_MODE') == "1":
        bb.warn("SULKA_DEVELOPMENT_MODE is enabled. This is not recommended for production builds.")
}

addhandler check_serviceuser_password
check_serviceuser_password[eventmask] = "bb.event.ConfigParsed bb.event.MultiConfigParsed"

python check_serviceuser_password () {
    import re
    serviceuser_password = (d.getVar('SULKA_SERVICEUSER_PASSWORD') or '')
    if serviceuser_password == '':
        bb.note("SULKA_SERVICEUSER_PASSWORD is not set, login user will not be created")
    # Check that all the dollar signs are preceded with escape symbol \
    elif re.search(r'(?<!\\)\$', serviceuser_password):
        bb.fatal("SULKA_SERVICEUSER_PASSWORD is set but contains unescaped dollar signs.\n"
                 "All dollar signs in the password hash must be escaped with backslashes.\n"
                 "Example: \\$y\\$j75\\$3fiNBCrfz.RN8NsLpBO5m1\\$WCX/KI3Kj9CLUgVZy1/ADEj8qnvlMzywGp5NcYTrx3A")
}

addhandler check_module_signing_keys
check_module_signing_keys[eventmask] = "bb.event.ConfigParsed bb.event.MultiConfigParsed"

python check_module_signing_keys () {
    mod_signing_enabled = (d.getVar('SULKA_ENABLE_MODULE_SIGNING') or '')

    if mod_signing_enabled == '1':
        ima_evm_root_ca = (d.getVar('IMA_EVM_ROOT_CA') or '')
        modsign_key_dir = (d.getVar('MODSIGN_KEY_DIR') or '')

        incorrect_configuration = False

        if ima_evm_root_ca == '':
            bb.error("IMA_EVM_ROOT_CA not set!")
            incorrect_configuration = True
        if modsign_key_dir == '':
            bb.error("MODSIGN_KEY_DIR not set!")
            incorrect_configuration = True
        if incorrect_configuration:
            bb.fatal("Module signing key configuration seems to be incorrect.\n"
                     "Either disable the feature by setting SULKA_ENABLE_MODULE_SIGNING = \"0\" in your build config\n"
                     "or generate the keys with generate_ima_evm_modsign_keys.sh script in kas-sulka and set the required\n"
                     "MODSIGN_KEY_DIR and IMA_EVM_ROOT_CA variables.")
}

addhandler check_verified_boot
check_verified_boot[eventmask] = "bb.event.ConfigParsed bb.event.MultiConfigParsed"

python check_verified_boot () {
    import os

    if d.getVar('SULKA_ENABLE_VERIFIED_BOOT') != "1":
        return

    if not d.getVar('SULKA_FIT_IMAGE_RECIPE'):
        bb.fatal("SULKA_ENABLE_VERIFIED_BOOT requires that you set the FIT image recipe name to SULKA_FIT_IMAGE_RECIPE.")

    if not (d.getVar('PREFERRED_PROVIDER_virtual/bootloader') or '').startswith('u-boot'):
        bb.fatal("SULKA_ENABLE_VERIFIED_BOOT requires U-Boot as the bootloader (PREFERRED_PROVIDER_virtual/bootloader).")

    keydir = d.getVar('UBOOT_SIGN_KEYDIR') or ''
    keyname = d.getVar('UBOOT_SIGN_KEYNAME') or ''
    if not keydir or not keyname or not os.path.exists(os.path.join(keydir, keyname + '.key')):
        bb.fatal("SULKA_ENABLE_VERIFIED_BOOT requires a FIT signing key, but %s/%s.key does not exist.\n"
                 "Generate the keys with generate_fit_signing_keys.sh in kas-sulka and set UBOOT_SIGN_KEYDIR and UBOOT_SIGN_KEYNAME."
                 % (keydir or '<UBOOT_SIGN_KEYDIR>', keyname or '<UBOOT_SIGN_KEYNAME>'))
}

addhandler selinux_variables
selinux_variables[eventmask] = "bb.event.ConfigParsed bb.event.MultiConfigParsed"

python selinux_variables () {
    first_boot_relabel = (d.getVar('FIRST_BOOT_RELABEL') or '')
    if first_boot_relabel == '1':
        bb.fatal("FIRST_BOOT_RELABEL for SELinux has been disabled in Sulka.\n"
                 "Fixfiles script needed for relabeling relies on bash, which is not included due to its GPLv3 License.\n"
                 "If you need run-time relabeling, please open an issue at https://codeberg.org/AltidSec/meta-sulka-distro/issues")
}
