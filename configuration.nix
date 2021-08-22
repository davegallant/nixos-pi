{ config, lib, pkgs, ... }:
let
  netdataConf = ./netdata.conf;
  netdataDir = "/var/lib/netdata";
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
    docker
    exa
    git
    glances
    htop
    iptables
    neovim
    netdata
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

  services.openssh.enable = true;

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
      41641  # Tailscale
    ];
    allowedTCPPorts = [
      80     # Adguard webui
      3000   # Adguard webui setup
      19999  # netdata webui
    ];
  };

  networking.hostName = "nixos-pi";

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
      extraGroups = [ "wheel" "docker" ];
      group = "nixos";
      home = "/home/nixos";
      name = "nixos";
      password = "nixos"; # change this on first login
      shell = pkgs.zsh;
      uid = 1000;
    };
  };

  systemd.services.netdata = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    preStart = ''
      mkdir -p ${netdataDir}/config
      mkdir -p ${netdataDir}/logs
      cp -r ${pkgs.netdata}/share/netdata/web ${netdataDir}/web
      chmod -R 700 ${netdataDir}
      chown -R nixos:nixos ${netdataDir}
    '';
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.netdata}/bin/netdata -c ${netdataConf} -u nixos";
      Restart = "on-failure";
    };
  };

  services.nginx.httpConfig = ''
    server {
      server_name netdata.thume.net;
      location / {
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:19999;
      }
    }
  '';

  system.stateVersion = "unstable";
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

}
