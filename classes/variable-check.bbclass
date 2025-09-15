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
}

addhandler check_serviceuser_password
check_serviceuser_password[eventmask] = "bb.event.ConfigParsed bb.event.MultiConfigParsed"

python check_serviceuser_password () {
    serviceuser_password = (d.getVar('SULKA_SERVICEUSER_PASSWORD') or '')
    if serviceuser_password == '':
        bb.note("SULKA_SERVICEUSER_PASSWORD is not set, login user will not be created")
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
