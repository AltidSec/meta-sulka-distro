# Sulka Yocto Distributon

Sulka is a Yocto Linux distribution that focuses on the security hardening.

## Features
- 🚧 Check and block of dangerous features like `DEBUG_TWEAKS`
- 🚒 `nftables` firewall and configuration template
- 🔑 Disabled root-login and added service user with sudo configuration template

## Motivation

The default reference distribution of Yocto, Poky, is a general-purpose distribution that is suitable for learning how to get started with Yocto. However, as it is meant mostly to be a reference, it has to make some compromises on security.

Sulka does not have to make such compromises, and it can focus on security. The goal is to make a distro that is as hardened as possible, and then the end user can make a conscious decision to lower hardening if so required.

For example, by default the distribution contains a firewall that drops everything, even outgoing traffic. The end user then has to make the decision on how to configure the firewall if they want to enable networking.

This makes the distribution require some setup before being actually usable, unlike the default reference Poky that can be used out-of-the-box. However, in the long run this makes it easier to ship secure devices when the distro is hardened by default.


## Getting Started

1. Clone the `poky` and `meta-sulka-distro` repositories. Clone the dependency `meta-openembedded` as well: 
```
git clone git://git.yoctoproject.org/poky
cd poky
git clone git://git.openembedded.org/meta-openembedded
git clone https://codeberg.org/AltidSec/meta-sulka-distro.git
```

2. Source the build environment to create the build directory:
```
source oe-init-build-env
``` 

3. Edit `conf/bblayers.conf`, remove `meta-poky` **and** add the meta-layers:
```
/path/to/meta-sulka-distro \
/path/to/meta-openembedded/meta-oe \
/path/to/meta-openembedded/meta-python \
/path/to/meta-openembedded/meta-networking \
```

4. Set `DISTRO` to `sulka` in `conf/local.conf`:
```
DISTRO = "sulka"
```

5. Generate a password for the service user that can be used to log in.
```
openssl passwd -6 ${PASSWORD}
```

6. Add the password to `conf/local.conf`. Escape dollar signs in hash with `\`:
```
SERVICEUSER_PASSWD = "<HASH_FROM_PREVIOUS COMMAND>"
```

7. (Optional) Edit the firewall template in `meta-sulka-distro/recipes-filter/nftables-configuration/files/nftables.conf.template`.

8. Build your image, for example `core-image-base`:
```
bitbake core-image-base
```
