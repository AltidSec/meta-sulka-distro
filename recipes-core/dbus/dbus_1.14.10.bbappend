# This should be identical to the main recipe, except that shell has been changed to nologin
USERADD_PARAM:dbus-common = "--system --home ${localstatedir}/lib/dbus \
                             --no-create-home --shell /sbin/nologin \
                             --user-group messagebus"
