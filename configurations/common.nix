{ config, pkgs, ... }:

{
  # enable nix-command and flakes, required for many workflows
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # install system packages
  environment.systemPackages = with pkgs; [
    # required cli tools
    curl
    git
    git-lfs
    gh
    unzip
    zstd
    wget

    # useful cli tools
    lazygit
    lazydocker
    tmux
    zellij
    neovim
    conda
    fzf
    ripgrep
    eza
    yazi
    bat
    fd
    starship
    btop
    htop
    cht-sh

    # useful nix utils
    manix
    nix-search-cli
    nix-output-monitor
  ];

  # enable zsh, set as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}