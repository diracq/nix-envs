{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    <nixos-wsl/modules>
  ];

  wsl.enable = true;

  # enable docker desktop integration
  wsl.docker-desktop.enable = true;
}
