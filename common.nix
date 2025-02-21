{ config, pkgs, ... }:

{
  # enable nix-command and flakes, required for many workflows
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;

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
    btop
    htop
    cht-sh

    # useful nix utils
    manix
    nix-search-cli
    nix-output-monitor
  ];

  # enable direnv for automatically activating nix shell
  programs.direnv.enable = true;

  # enable zsh, set as default shell
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # enable direnv hook
    shellInit = ''
      eval "$(direnv hook zsh)"
    '';
  };

  programs.fzf = {
    keybindings = true;
  };

  programs.starship = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
}
