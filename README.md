# NixOS Pi

[![Build OS Image](https://github.com/davegallant/nixos-pi/actions/workflows/build-sd-image.yaml/badge.svg)](https://github.com/davegallant/nixos-pi/actions/workflows/build-sd-image.yaml)

> :warning: The GitHub actions build is currently pinned to an outdated version of nixpkgs because of [this](https://github.com/NixOS/nixpkgs/pull/128532) issue

This repo contains configuration for creating an NixOS image that runs on a Raspberry Pi.

It contains the following services:
  - [AdGuardHome](https://github.com/AdguardTeam/AdGuardHome)
  - [Tailscale](https://tailscale.com/)
  - [netdata](https://github.com/netdata/netdata)

## Motivation

Because [Reproducible Builds](https://reproducible-builds.org/) matter.

And also, SD cards are not the most reliable form of storage, especially when they are operating non-stop. Because of this, I wanted a simple way to build a reproducible OS image that will run on a [Raspberry Pi](https://www.raspberrypi.org/).

## Installation

### Github Actions

The workflow runs on Ubuntu and emulates the ARM platform with QEMU.

When the build finishes, there will be an artifact named `sd-image.img.zip`.

### Extract

This archive can be decompressed and the image can flashed on an SD card and used to boot up the OS.

```bash
unzip sd-image.img.zip
unzstd nixos-sd-image-21.05pre-git-aarch64-linux.img.zst
```

### Flash to SD

The image can be flashed using the [Raspberry Pi Imager](https://www.raspberrypi.org/blog/raspberry-pi-imager-imaging-utility/) or a simpler tool such as [dd](https://man7.org/linux/man-pages/man1/dd.1.html).

### SSH


The default user/password is `nixos/nixos` with SSH enabled. Either change the password on initial login, or enable an authorized key and disable the password.

## Addtional Resources

- [NixOS on ARM](https://nixos.wiki/wiki/NixOS_on_ARM#Installation)
