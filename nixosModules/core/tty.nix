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
    ripdrag
    lsd
    stow
    zoxide

    # Editors
    vim

    # Terminal Emulators
    foot
    kitty
    
    # Ricing
    fastfetch
  ];
}
