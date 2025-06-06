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
}

addhandler check_serviceuser_password
check_serviceuser_password[eventmask] = "bb.event.ConfigParsed bb.event.MultiConfigParsed"

python check_serviceuser_password () {
    serviceuser_password = (d.getVar('SULKA_SERVICEUSER_PASSWORD') or '')
    if serviceuser_password == '':
        bb.note("SULKA_SERVICEUSER_PASSWORD is not set, login user will not be created")
}
