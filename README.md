# NixOS Pi

[![Build OS Image](https://github.com/davegallant/nixos-pi/actions/workflows/build-sd-image.yaml/badge.svg)](https://github.com/davegallant/nixos-pi/actions/workflows/build-sd-image.yaml)

This repo contains configuration for creating an NixOS image that runs on a Raspberry Pi.

## Github Actions

The workflow emulates the ARM platform with QEMU.

When the build finishs, there will be an artifact named `sd-image.img`.

This image can be flashed on an SD card and used to boot up the OS.

# Resources

- [ARM installation notes](https://nixos.wiki/wiki/NixOS_on_ARM#Installation)
- [Pi3 installation notes](https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_3#Board-specific_installation_notes)
