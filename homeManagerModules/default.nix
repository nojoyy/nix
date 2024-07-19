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
    librewolf
    keepassxc
    libreoffice-qt
    filezilla
    
    # Misc Utils
    gimp
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
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/noah/etc/profile.d/hm-session-vars.sh

  home.sessionVariables = {
    EDITOR = "emacsclient";
    GTK_USE_PORTAL = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
