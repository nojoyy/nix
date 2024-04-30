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
    libreoffice-qt
    
    # Shells, Terminals, and Shell Accessories
    zoxide
    fzf
    zellij

    # GNU Stuff 
    stow

    # Misc Utils
    gimp
    lazygit
    
    emacs-pgtk
   ];

  # Enable Emacs
  services.emacs.package = pkgs.emacs-pgtk;
  services.emacs.enable = true;

  # wlogout
  programs.wlogout.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-BL";
      package = pkgs.tokyo-night-gtk;
    };
    font = {
      name = "Fira Medium";
      package = pkgs.fira;
      size = 11;
    };
    iconTheme = {
      name = "Tokyonight-Dark-Cyan";
      package = pkgs.tokyo-night-gtk;
    };
  };

  # Clear tofi cache to update desktop entries
 home.activation = {
   # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
   regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                       tofi_cache=${config.xdg.cacheHome}/tofi-drun
                       [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
                       '';
 };

  # Session Variables
  home.sessionVariables = {
    EDITOR = "emacs";
    GTK_USE_PORTAL = "1";
  };

}
