{ config, pkgs, lib, ... }:

{

  # Default Modules
  imports = [
    ./../homeManagerModules/pcmanfm.nix
    ./../homeManagerModules/hyprland.nix
  ];
  
  # General Home Manager Config
  home.username = "noah";

  #General Packages
  home.packages = with pkgs; [ 
    # Desktop
    firefox
    keepassxc
    libreoffice-qt
    filezilla
    
    # Shells, Terminals, and Shell Accessories
    zoxide
    fzf
    zellij

    # GNU Stuff 
    stow

    # Misc Utils
    gimp
    lazygit
   ];

  # Enable Emacs
  services.emacs.enable = true;
  services.emacs.package = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages ( epkgs: with epkgs; [
        vterm # vterm needs to pre compiled
        treesit-grammars.with-all-grammars # as well as treesit grammars
      ]);


  # wlogout
  programs.wlogout.enable = true;

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Tokyonight-Dark-BL";
  #     package = pkgs.tokyo-night-gtk;
  #   };
  #   font = {
  #     name = "Fira Medium";
  #     package = pkgs.fira;
  #     size = 11;
  #   };
  #   iconTheme = {
  #     name = "Tokyonight-Dark-Cyan";
  #     package = pkgs.tokyo-night-gtk;
  #   };
  # };

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
    EDITOR = "emacsclient";
    GTK_USE_PORTAL = "1";
  };
}
