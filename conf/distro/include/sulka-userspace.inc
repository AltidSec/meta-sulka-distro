INHERIT += "extrausers"

SULKA_SERVICEUSER_USERNAME ??= "serviceuser"
SULKA_SERVICEUSER_PASSWORD ??= ""
SULKA_SERVICEUSER_HOME = "/home/${SULKA_SERVICEUSER_USERNAME}"
SULKA_SERVICEUSER_GROUPADD = " groupadd -g 1200 ${SULKA_SERVICEUSER_USERNAME};"
SULKA_SERVICEUSER_USERADD = " useradd -u 1200 -g 1200 -s /bin/sh -d ${SULKA_SERVICEUSER_HOME} -M -p '${SULKA_SERVICEUSER_PASSWORD}' ${SULKA_SERVICEUSER_USERNAME};"
EXTRA_USERS_PARAMS:append = "${@"${SULKA_SERVICEUSER_GROUPADD} ${SULKA_SERVICEUSER_USERADD}" if d.getVar('SULKA_SERVICEUSER_PASSWORD') else ""}"

SULKA_SERVICEUSER_ENABLE_SUDO ??= "0"

EXTRA_USERS_PARAMS:append = "\
    usermod -s /sbin/nologin root; \
    usermod -s /sbin/nologin sync; \
"

INHERIT += "sulka-rootfs-postprocess"

SULKA_INSTALL_SSH_KEYS ??= "0"
INHERIT += "${@"sulka-install-ssh-keys" if d.getVar('SULKA_INSTALL_SSH_KEYS') == "1" else ""}"

# Option to enable password expiration. This is disabled by default, as the password expiration
# requirement does not translate well into the embedded devices. However, if you have a system
# where logins are often performed, consider enabling password expiration. Also, if
# SULKA_EXTRA_COMPLIANCY is enabled, enable password expiration
SULKA_EXPIRE_PASSWORDS ??= "0"
SULKA_EXPIRE_PASSWORDS:sulka-compliancy = "1"
OVERRIDES:append = "${@":sulka-expire-passwords" if d.getVar('SULKA_EXPIRE_PASSWORDS') == "1" else ""}"

# Harden the mount options of the default mounts of the system: base-files'
# stock fstab (hidepid on /proc, nodev,nosuid,noexec on the volatile tmpfs
# mounts) and systemd's tmp.mount unit (noexec on /tmp). Mounts that you add
# yourself are never touched by this option. Set to "0" if you ship your own
# fstab and the hardening does not apply to it
SULKA_HARDEN_MOUNTS ??= "1"
OVERRIDES:append = "${@":sulka-harden-mounts" if d.getVar('SULKA_HARDEN_MOUNTS') == "1" else ""}"

SULKA_SSH_PORT ??= "22"

# Option to set the mandatory access control module. Currently, accepted values are "none" and
# "selinux". Other values have the same effect as "none", i.e. no effect.
SULKA_MANDATORY_ACCESS_CONTROL_MODULE ??= "selinux"
DISTRO_EXTRA_RDEPENDS:append = "${@" packagegroup-selinux-minimal " if d.getVar('SULKA_MANDATORY_ACCESS_CONTROL_MODULE') == "selinux" else ""}"
DISTRO_FEATURES:append = "${@" selinux " if d.getVar('SULKA_MANDATORY_ACCESS_CONTROL_MODULE') == "selinux" else ""}"
IMAGE_CLASSES:append = "${@" selinux-image " if d.getVar('SULKA_MANDATORY_ACCESS_CONTROL_MODULE') == "selinux" else ""}"
PREFERRED_PROVIDER_virtual/refpolicy ?= "refpolicy-targeted"
