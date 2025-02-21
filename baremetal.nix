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
    qalculate-gtk
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    # polkitPolicyOwners = [ "yourUsernameHere" ];
  };
}
