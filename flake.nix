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
      };

  in {

    nixpkgs.config = {
      packageOverrides = pkgs: {
        emacs = pkgs.lib.overriderDerivation (pkgs.emacs.override {
        withGTK2 = true;
        withGTK3 = false;
        });
        allowUnfree = true;
      };
    };
    
    # Home Manager Configurations
    homeConfigurations = {
      "noah@Sapphire" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/Sapphire.nix
          ./home/general.nix
          ./modules/obs.nix
        ];
        extraSpecialArgs = { inherit nixpkgs emacs hyprland ;};
      };
      
      "noah@Ruby" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home/Ruby.nix
          ./home/general.nix
        ];
        extraSpecialArgs = { inherit nixpkgs emacs hyprland; };
      };
    };
    
    # Nixos configurations
    nixosConfigurations.Sapphire = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/Sapphire.nix
        ./system/general.nix
        ./system/Sapphire.nix
        ./system/locale.nix
        ./system/noah.nix
        ./system/carbon.nix
        ./system/graphical.nix
        ./system/ssh.nix
        ./system/pipewire.nix
        ./system/polkit.nix
        ./system/v4l2loopback.nix
        ./system/steam.nix
        ./modules/docker.nix
      ];
    };
    
    nixosConfigurations.Ruby = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware/Ruby.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ./system/general.nix
        ./system/Ruby.nix
        ./system/locale.nix
        ./system/noah.nix
        ./system/carbon.nix
        ./system/graphical.nix
        ./system/pipewire.nix
        ./system/polkit.nix
      ];
    };
  };
}
