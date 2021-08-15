{ config, lib, pkgs, ... }:
let
  changedetectionDir = "/var/lib/changedetection.io/";
in
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
    changedetection.io
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
    zip
  ];

  nixpkgs.overlays = [ (import ./overlays) ];

  services.openssh = { enable = true; };

  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 3000;
  };

  systemd.services.changedetection = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    preStart = ''
      mkdir -p ${changedetectionDir}/datastore
    '';
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.changedetection.io}/bin/changedetection.py -d ${changedetectionDir}/datastore";
      Restart = "on-failure";
    };
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "bira";
    };
  };

  virtualisation.docker.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      80 
      3000 # Adguard UI
      5000 # Changedeteciton.io
    ];
    allowedUDPPorts = [ 53 ]; # Adguard DNS
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
  users.extraUsers.nixos.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlUwUlnO16Uk1+xGXaYp+XknQKdLyoIqxPHn9PNmAefhaU7HbzN3lHo+oYdCycG5PGo2gyHWud0KwiZZTC4mKUCH6rK4kpcOCIAOLRPX3SPxe9Fmgfm4HJHQot9m6Atc/BsLsF7B3n7jgp2FHFueZttUTPsJFd/5a5XZWKjfJh2E4SBMewVN8STVC3B0XLm+/WHOY5WSz3YknWD+6BRsyyOS/ogN2RuqvwPOC+zfRBrFgB0usna1KP91o79qSqMg/BGc4FK5ZSRFe8eHKVix9MQSkCk50RmyiUbVK+fxbkyKyMYwhSNBrZLfWM7kJN+UuK6Jo4jAweN82b6yO/PMzn dave@hephaestus"
  ];

  system.stateVersion = "unstable";
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

}
