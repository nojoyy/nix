{ config, inputs, pkgs, ... }:

{

  # Additional Modules
  imports = [
    ./locale.nix
    ./users/noah.nix
    ./graphical.nix
    ./../modules/pipewire.nix
    ./../modules/polkit.nix
    ./../modules/ssh.nix
    ./../modules/sddm.nix
  ];
  
  # Enable chachix for hyprland   
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

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
    vim 
    wget
    git
    cmake
    vlc
    obsidian
    unzip
    rpi-imager
    cachix
    tigervnc
  ];

  # HYPRLAND
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # STYLIX
  stylix.base16Scheme = {
  base00 = "1C2023"; # ----
  base01 = "393F45"; # ---
  base02 = "565E65"; # --
  base03 = "747C84"; # -
  base04 = "ADB3BA"; # +
  base05 = "C7CCD1"; # ++
  base06 = "DFE2E5"; # +++
  base07 = "F3F4F5"; # ++++
  base08 = "C7AE95"; # orange
  base09 = "C7C795"; # yellow
  base0A = "AEC795"; # poison green
  base0B = "95C7AE"; # turquois
  base0C = "95AEC7"; # aqua
  base0D = "AE95C7"; # purple
  base0E = "C795AE"; # pink
  base0F = "C79595"; # light red
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
      name = "FiraCode Nerd Font";
    };
    sansSerif = {
      package = pkgs.fira-sans;
      name = "Fira Sans";
    };
  };

  stylix.image = /home/noah/dotfiles/hypr/wallpapers/contemplate.jpg;
}
