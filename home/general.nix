{ config, pkgs, lib, ... }:

{
  # General Home Manager Config
  home.username = "noah";
  home.homeDirectory = "/home/noah/";

  #General Packages
  home.packages = with pkgs; [ 
    # Desktop
    firefox
    keepassxc
    xfce.thunar
    libreoffice-qt
    
    # Shells, Terminals, and Shell Accessories
    zoxide
    fzf
    zellij

    # GNU Stuff 
    stow

    # Misc Utils
    gimp
    zathura
    lazygit
    
    emacs-unstable
   ];

  # Enable Emacs
  services.emacs.enable = true;

  # wlogout
  programs.wlogout.enable = true;

  # Clear tofi cache to update desktop entries
 # home.activation = {
 #   # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
 #   regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
 #                       tofi_cache=${config.xdg.cacheHome}/tofi-drun
 #                       [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
 #                       '';
 # };

  # Session Variables
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

}
