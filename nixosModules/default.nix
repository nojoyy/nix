{ pkgs, config, inputs, ... }:

{

  # Additional Modules
  imports = [
    ./../users/noah.nix
    ./ai
    ./core
    ./development
    ./obs.nix
    ./steam.nix
  ];

  # Enable chachix for hyprland   
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  home-manager.backupFileExtension = "~/.backup";

  # Add QEMU/VM Support
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.noah.extraGroups = [ "libvirtd" ];
  
  # Nix Helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/noah/.nixos/";
  };

  services.gvfs.enable = true;

  # Network Manager
  networking.networkmanager.enable = true; 

  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Fonts
  fonts.packages = with pkgs; [ fira-code font-awesome fira-code-nerdfont fira ];

  # System level package
  environment.systemPackages = with pkgs; [
    cmake
    vlc
    obsidian
    rpi-imager
    cachix
    ags
    xdg-desktop-portal
  ];

  # HYPRLAND
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # WAYDROID
  virtualisation.waydroid.enable = true;

  # EMACS DAEMON
  services.emacs = {
    enable = true;
    package = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages ( epkgs: with epkgs; [
        vterm # vterm needs to pre compiled
        treesit-grammars.with-all-grammars # as well as treesit grammars
      ]);
  };

  # STYLIX
  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-dark.yaml";


    # base16Scheme = {
    #   base00 = "1C1E26";
    #   base01 = "232530";
    #   base02 = "2E303E";
    #   base03 = "6F6F70";
    #   base04 = "9DA0A2";
    #   base05 = "CBCED0";
    #   base06 = "DCDFE4";
    #   base07 = "E3E6EE";
    #   base08 = "E93C58";
    #   base09 = "E58D7D";
    #   base0A = "EFB993";
    #   base0B = "EFAF8E";
    #   base0C = "24A8B4";
    #   base0D = "DF5273";
    #   base0E = "B072D1";
    #   base0F = "E4A382";
    # };
    

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
        name = "FiraCode Nerd Font";
      };
      sansSerif = {
        package = pkgs.fira-sans;
        name = "Fira Sans";
      };
      serif = config.stylix.fonts.sansSerif;
    };

    homeManagerIntegration.autoImport = true;

    image = /home/noah/.dotfiles/hypr/wallpapers/sunset_city.jpg;
  };
}
