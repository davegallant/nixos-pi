let _pkgs = import <nixpkgs> { };
in { pkgs ? import (_pkgs.fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "8e4fe32876ca15e3d5eb3ecd3ca0b224417f5f17";
  sha256 = "sha256-R7WAb8EnkIJxxaF6GTHUPytjonhB4Zm0iatyWoW169A=";
}) { } }:

with pkgs;

mkShell { buildInputs = [ git qemu qemu_kvm ]; }
