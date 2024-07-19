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
    fzf
    lf
    lsd
    stow
    zoxide

    # Editors
    vim
    neovim

    # Terminal Emulators
    foot
    
    # Terminal Multiplexors
    tmux
    zellij

    # Ricing
    cava
    fastfetch
    neofetch
  ];
}
