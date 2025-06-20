{ pkgs, lib, config, ... }:

let module = config.modules.stylix;

in {

  # options
  options = {
    modules.stylix.enable = lib.mkEnableOption "stylix";
  };

  config =  lib.mkIf module.enable {
    stylix = {
      enable = lib.mkDefault true;
      autoEnable = false;
      
      # based on tokyo night dark
      base16Scheme = {
        base00 = "#1a1b26";
        base01 = "#24283b";
        base02 = "#414868";
        base03 = "#9aa5ce";
        base04 = "#a9b1d6";
        base05 = "#cfc9c2";
        base06 = "#c0caf5";
        base07 = "#bb9af7";
        base08 = "#f7768e";
        base09 = "#ff9e64";
        base0A = "#e0af68";
        base0B = "#9ece6a";
        base0C = "#2ac3de";
        base0D = "#7dcfff";
        base0E = "#7aa2f7";
        base0F = "#b4f9f8";
      };
      
      # font configuration
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
        };
        sansSerif = {
          package = pkgs.fira-sans;
          name = "Fira Sans";
        };
        sizes = {
          terminal = 12;
          applications = 12;
          desktop = 10;
          popups = 12;
        };
      };
      
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
      
      targets = {
        console.enable = true;
        fish.enable = true;
        gnome.enable = false;
        grub.enable = true;
        gtk.enable = true;
      };

    };
  };
}
  
