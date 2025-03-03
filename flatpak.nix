{ config, pkgs, ... }:
let
  # flatpak packages we want
  desiredFlatpaks = [
    "us.zoom.Zoom"
  ];
in
{
  system.userActivationScripts.flatpakManagement = {
    text = ''
      # add flathub repo
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo

      # install or re-install the flatpaks we want
      for app in ${toString desiredFlatpaks}; do
        echo "Ensuring $app is installed."
        ${pkgs.flatpak}/bin/flatpak install -y flathub $app
      done

      # remove unused flatpaks
      ${pkgs.flatpak}/bin/flatpak uninstall --unused -y

      # update all flatpaks
      ${pkgs.flatpak}/bin/flatpak update -y
    '';
  };
}
