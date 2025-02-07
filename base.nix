{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld = {
    enable = true;
  };
}
