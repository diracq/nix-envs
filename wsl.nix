{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  wsl.enable = true;
  wsl.docker-desktop.enable = true;

}
