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
    gh
    unzip
    zstd
    wget

    # useful cli tools
    atuin
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
    nushell

    # useful nix utils
    manix
    nix-search-cli
    nix-output-monitor
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      push = {
        autoSetupRemote = true;
      };
    };
  };

  # enable and configure zsh, set as default shell
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellInit = ''
      eval "$(atuin init zsh)"
    '';
  };
  users.defaultUserShell = pkgs.zsh;

  # enable direnv for automatically activating nix shell in buildos-web
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    keybindings = false;
  };

  programs.starship = {
    enable = true;
  };

  services.atuin = {
    enable = true;
  };
}
