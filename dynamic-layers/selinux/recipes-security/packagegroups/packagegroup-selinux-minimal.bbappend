# Remove coreutils to avoid installing GPLv3 licensed packages

# fixfiles script relies on bashisms, but bash should not be installed
# by default due to GPLv3 license. Remove fixfiles, and remove
# autorelabel script that relies on fixfiles script
RDEPENDS:${PN}:remove = "\
	coreutils \
	policycoreutils-fixfiles \
	selinux-autorelabel \
"

