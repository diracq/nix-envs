{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  environment.systemPackages = with pkgs; [
    # required gui tools
    google-chrome
    firefox
    slack
    postman

    # useful gui tools
    code-cursor
    vlc
    qalculate
  ];

}
