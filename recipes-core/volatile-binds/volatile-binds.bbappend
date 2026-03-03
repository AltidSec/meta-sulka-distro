VOLATILE_BINDS = "\
    ${localstatedir}/volatile/lib ${localstatedir}/lib\n\
    ${localstatedir}/volatile/cache ${localstatedir}/cache\n\
"

# Avoid overlayfs as that has problems with SELinux. The downside is that
# this increases the boot times. If you disable SELinux and want to reduce
# the boot time as well, it is recommended to override this to 0
AVOID_OVERLAYFS = "1"
