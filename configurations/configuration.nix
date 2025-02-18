{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  wsl.enable = true;

  # enable docker desktop integration
  wsl.docker-desktop.enable = true;

  # patch server so vscode and cursor remote can be used
  vscode-remote-workaround.enable = true;
}
