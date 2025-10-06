# Sulka Yocto Distributon

Sulka is a Yocto Linux distribution that focuses on the security hardening.

## Features
- 🚧 Check and block dangerous features like `DEBUG_TWEAKS`
- 🚒 `nftables` firewall and configuration templates
- 🔑 Disabled root-login and added service user with sudo configuration template
- ❓ Enforce secure passwords
- 🔎 Mandatory access control with SELinux
- 🐢 Applied hardening information from [Lynis](https://cisofy.com/lynis/) and [OpenSCAP](https://www.open-scap.org/)

## Motivation

The default reference distribution of Yocto, Poky, is a general-purpose distribution that is suitable for learning how to get started with Yocto. However, as it is meant mostly to be a reference, it has to make some compromises on security.

Sulka does not have to make such compromises, and it can focus on security. The goal is to make a distro that is as hardened as possible, and then the end user can make a conscious decision to lower hardening if so required.

For example, by default the distribution contains a firewall that drops everything, even outgoing traffic. The end user then has to make the decision on how to configure the firewall if they want to enable networking.

This makes the distribution require some setup before being actually usable, unlike the default reference Poky that can be used out-of-the-box. However, in the long run this makes it easier to ship secure devices when the distro is hardened by default.


## Getting Started and Documentation
To get started with Sulka, you can read [the quick start guide online](https://altidsec.com/sulka/documentation/quick-start.html). If website is not available, you can also read the contents from [the documentation repository](https://codeberg.org/AltidSec/sulka-docs/src/branch/main/source/quick-start.rst).

More information about Sulka can be found from [the user guide](https://altidsec.com/sulka/documentation/user-guide.html).

## Contributing

Send pull requests, patches, comments or questions to the AltidSec repositories in Codeberg, and feel free to open issues to start discussions. Use `*-next` branches as pull request targets.

Maintainer:
Esa Jääskelä <esa.jaaskela@suomi24.fi>
