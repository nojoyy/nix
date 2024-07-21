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

    # Tracking issue with orcaslicer
    hyprland = {
      url = "https://github.com/hyprwm/Hyprland/releases/download/v0.41.1/source-v0.41.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix"; 
    
    nixos-hardware.url = "github:tracteurblinde/nixos-hardware/surface-linux-6.8.1";

    nil.url = "github:oxalica/nil";
  };

  outputs = {nixpkgs, home-manager, stylix, ...}@inputs: 

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
    nixosConfigurations.Sapphire = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./hosts/Sapphire/hardware-configuration.nix
        ./hosts/Sapphire/configuration.nix
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noah = import ./hosts/Sapphire/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
      specialArgs = { inherit inputs; };
    };
    
    nixosConfigurations.Ruby = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./hosts/Ruby/hardware-configuration.nix
        ./hosts/Ruby/configuration.nix
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noah = import ./hosts/Ruby/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
