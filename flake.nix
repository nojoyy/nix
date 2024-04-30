{
  description = "Nixos config flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:tracteurblinde/nixos-hardware/surface-linux-6.8.1";
  };

  outputs = { self, home-manager, nixpkgs, nixos-hardware, emacs, hyprland, ... }:

    let 
      system = "x86_64-linux";


      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          emacs.overlay
        ];
      };

  in {
    # Home Manager Configurations
    homeConfigurations = {
      "noah@Sapphire" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/Sapphire.nix
          ./home/general.nix
          hyprland.homeManagerModules.default
          ./modules/hyprland.nix
          ./modules/pcmanfm.nix
          ./modules/obs.nix
        ];
      };
      
      "noah@Ruby" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home/Ruby.nix
          ./home/general.nix
          hyprland.homeManagerModules.default
          ./modules/hyprland.nix
        ];
      };
    };
    
    # Nixos configurations
    nixosConfigurations.Sapphire = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./hardware/Sapphire.nix
        ./system/general.nix
        ./system/Sapphire.nix
        ./system/locale.nix
        ./home/users/noah.nix
        ./system/carbon.nix
	      ./system/graphical.nix
	      ./modules/sddm.nix
        ./modules/v4l2loopback.nix
        ./modules/ssh.nix
        ./modules/pipewire.nix
        ./modules/polkit.nix
        ./modules/steam.nix
        ./modules/docker.nix
      ];
    };
    
    nixosConfigurations.Ruby = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./hardware/Ruby.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ./system/general.nix
        ./system/Ruby.nix
        ./system/locale.nix
        ./home/users/noah.nix
        ./system/carbon.nix
        ./system/graphical.nix
        ./modules/sddm.nix
        ./modules/pipewire.nix
        ./modules/polkit.nix
      ];
    };
  };
}
