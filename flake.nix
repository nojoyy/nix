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

    stylix.url = "github:danth/stylix"; 
    
    nixos-hardware.url = "github:tracteurblinde/nixos-hardware/surface-linux-6.8.1";
  };

  outputs = {nixpkgs, ...}@inputs: 

    let 
      system = "x86_64-linux";


      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.emacs.overlay
        ];
      };

  in {
    # Home Manager Configurations
    homeConfigurations = {
      "noah@Sapphire" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/Sapphire.nix
          inputs.hyprland.homeManagerModules.default
        ];
      };
      
      "noah@Ruby" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home/Ruby.nix
          inputs.hyprland.homeManagerModules.default
        ];
      };
    };
    
    # Nixos configurations
    nixosConfigurations.Sapphire = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./system/Sapphire.nix
        ./hardware/Sapphire.nix
        inputs.stylix.nixosModules.stylix
      ];
    };
    
    nixosConfigurations.Ruby = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./system/Ruby.nix
        ./hardware/Ruby.nix
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
