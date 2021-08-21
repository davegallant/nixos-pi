{ config, lib, pkgs, ... }:
{

  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix>

    # For nixpkgs cache
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  sdImage.compressImage = true;

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_5_4;
    kernelParams = [ "cma=256M" ];
  };

  environment.systemPackages = with pkgs; [
    bat
    bind
    curl
    docker
    exa
    git
    glances
    htop
    iptables
    neovim
    openvpn
    pfetch
    procs
    python3
    ripgrep
    starship
    tailscale
    zip
  ];

  nixpkgs.overlays = [ (import ./overlays) ];

  # SSH should be disabled after tailscale is enabled!
  services.openssh = {
    enable = true;
    extraConfig = ''
      PermitEmptyPasswords yes
    '';
  };

  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 3000;
  };

  services.tailscale = { enable = true; };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "bira";
    };
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      53     # Adguard DNS
      41641  # Tailscale tunnel
    ];
  };

  # WiFi
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.wireless-regdb ];
  };

  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = true;
  users.groups = {
    nixos = {
      gid = 1000;
      name = "nixos";
    };
  };
  users.users = {
    nixos = {
      uid = 1000;
      home = "/home/nixos";
      name = "nixos";
      group = "nixos";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" ];
    };
  };

  system.stateVersion = "unstable";
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

}
