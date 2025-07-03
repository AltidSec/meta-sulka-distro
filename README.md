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
1. Follow instructions in [the kas-sulka repository](https://codeberg.org/AltidSec/kas-sulka/) to install and activate [kas](https://github.com/siemens/kas).

1. Clone the `kas-sulka` repository to build Sulka with kas:
    ```
    git clone https://codeberg.org/AltidSec/kas-sulka.git
    cd kas-sulka
    ```

1. Generate a password for the service user that can be used to log in.
    ```
    mkpasswd -m yescrypt -s -R 8 <SECRET_PASSWORD>
    ```

1. Add the password to `kas-sulka-configuration.yml`. Escape the four dollar signs in hash with `\`:
    ```
    SULKA_SERVICEUSER_PASSWORD = "<HASH_FROM_PREVIOUS COMMAND>"
    ```

1. (Optional) Change the default service user username `serviceuser` to something else by adding it to `kas-sulka-configuration.yml`:
    ```
    SULKA_SERVICEUSER_USERNAME = "<USERNAME>"
    ```

1. (Optional) Enable the graphics support if your device requires it:
    ```
    SULKA_DISABLE_GRAPHICS = "0"
    ```

1. (Optional) If editing the files in `meta-sulka-distro`, checkout the meta-layers first:
    ```
    kas checkout kas-sulka.yml
    ```

1. (Optional) Edit the firewall template in `meta-sulka-distro/recipes-filter/nftables-configuration/files/nftables-drop-everything.conf`, or select one of the other templates with `SULKA_NFTABLES_CONF` configuration variable.

1. (Optional) Edit the sudo configuration for the service user in `meta-sulka-distro/recipes-extended/sudo/files/serviceuser.conf` to enable sudo.

1. Build the image:
    ```
    kas build kas-sulka.yml
    ```

1. Run the image, and login as the service user using the password defined earlier
