{pkgs, lib, config, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core Utils
    git
    unzip
    wget
    zip

    # Shells
    fish
    zsh

    # Prompts
    starship

    # Tools
    ripgrep
    fzf
    lf
    ripdrag
    lsd
    stow
    zoxide

    # Editors
    vim
    neovim

    # Terminal Emulators
    foot
    kitty
    
    # Terminal Multiplexors
    tmux
    zellij

    # Ricing
    fastfetch
    neofetch
  ];
}
