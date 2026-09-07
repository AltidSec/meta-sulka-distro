# meta-sulka-distro

This meta-layer defines the Sulka distribution and the userspace hardening that goes with it.

Sulka is a Yocto Linux distribution that focuses on security hardening.
It ships hardened defaults across the kernel, the bootloader and the userspace, and expects the integrator to consciously relax hardening where their product requires it, rather than the other way round.

## What This Layer Provides

- **The distro definition.** `conf/distro/sulka.conf` sets the `sulka` distro. It is deliberately thin: distro identity and build configuration only. The hardening itself lives in `conf/distro/include/`, split into `sulka-image.inc` (distro features, package selection, SBOM tooling, read-only root file system), `sulka-userspace.inc` (users and login, mount options, SSH, mandatory access control) and `sulka-kernel.inc`, gathered by `conf/distro/include/sulka-hardening.inc`.
- **Login and user hardening.** Root and `sync` logins are disabled by setting their shells to `nologin`. An optional service user can be created, with a `sudo` configuration template for privileged actions. PAM enforces password quality, core dumps are disabled through `limits.d`, and password expiration can be enabled.
- **Firewall.** The `nftables-configuration` recipe ships a service, an init script and a set of rule templates, ranging from dropping all traffic in every direction to allowing established connections, loopback, SSH and ICMP.
- **Mandatory access control.** SELinux is supported through `meta-selinux`. The content lives under `dynamic-layers/selinux/` and activates only when that layer is present.
- **Auditing and logging.** `auditd` is configured with STIG rule set, and `syslog-ng` is the default syslog provider.
- **Image post-processing.** A rootfs postprocess class applies the final hardening steps, SSH keys can optionally be installed at build time, and a variable-check class fails the build on dangerous settings such as `DEBUG_TWEAKS`.
- **Read-only root file system** support, including the image feature and file system type wiring.
- **License hygiene.** GPLv3 components are avoided.

## Using the Hardening From Another Distro

The hardening is not tied to the `sulka` distro. Nothing under `conf/distro/include/` sets `DISTRO` or any other distro identity variable, and the recipe metadata is tied to `sulka-hardening` override rather than the distro name, so an existing distro can adopt it by adding this layer to `BBLAYERS` and requiring the same file `sulka.conf` does:

```
require conf/distro/include/sulka-hardening.inc
```

## Layer Information

| | |
|---|---|
| Layer name | `meta-sulka-distro` |
| Priority | 11 |
| Yocto compatibility | Scarthgap (`LAYERSERIES_COMPAT = "scarthgap"`) |
| Depends on | `core`, `networking-layer`, `security`, `openembedded-layer` |
| Conditional dependencies | `selinux` when SELinux is the mandatory access control module, `meta-sulka-kernel` when kernel hardening or graphics removal is enabled |

This layer can be used outside the kas Sulka build, but most of its bbappends name the exact upstream version they apply to, which ties it to particular versions of `openembedded-core` and `meta-openembedded`.
A mismatch fails the build as a dangling bbappend rather than quietly dropping the hardening, so version drift is easy to spot.

The easiest route is therefore the [kas Sulka](https://codeberg.org/AltidSec/kas-sulka) build configuration, which pins compatible revisions of everything listed above, but integrating the layer into an existing build works too as long as the recipe versions line up.
In the long run the goal is for this to be a general-purpose add-on layer, with the bbappends following each recipe's major version rather than an exact one.

## Documentation

To get started, read [the quick start guide](https://altidsec.com/sulka/documentation/quick-start.html).
The [user guide](https://altidsec.com/sulka/documentation/user-guide.html) covers the distro in depth, including the [firewall](https://altidsec.com/sulka/documentation/user-guide.html#firewall), [SELinux](https://altidsec.com/sulka/documentation/user-guide.html#selinux), [monitoring](https://altidsec.com/sulka/documentation/user-guide.html#monitoring), [read-only root file system](https://altidsec.com/sulka/documentation/user-guide.html#read-only-root-file-system) and the full list of [configuration variables](https://altidsec.com/sulka/documentation/user-guide.html#configuration-variables).

If the website is unavailable, the same content can be read from [the documentation repository](https://codeberg.org/AltidSec/sulka-docs/src/branch/main/source).

## Contributing

Send pull requests, patches, comments or questions to the AltidSec repositories in Codeberg, and feel free to open issues to start discussions. Use `*-next` branches as pull request targets.

Maintainer:
Esa Jääskelä <esa.jaaskela@suomi24.fi>

## License

The metadata in this layer is licensed under the MIT license. See [COPYING.MIT](COPYING.MIT) for the full text.
Individual recipes fetch and build upstream components under their own licenses.
