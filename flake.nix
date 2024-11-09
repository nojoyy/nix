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
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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
        # system entrypoints
        ./hosts/Sapphire/hardware-configuration.nix
        ./hosts/Sapphire/configuration.nix

        # home-manager setup
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noah = import ./hosts/Sapphire/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }

        # interacts with both home-manager and nix
        stylix.nixosModules.stylix
      ];
      specialArgs = { inherit inputs; };
    };
    
    nixosConfigurations.Ruby = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        # my entrypoints
        ./hosts/Ruby/hardware-configuration.nix
        ./hosts/Ruby/configuration.nix

        # home-manager setup
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noah = import ./hosts/Ruby/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }

        # interacts with both home-manager and nix
        stylix.nixosModules.stylix

        # hardware specific
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
      ];
      specialArgs = { inherit inputs; };
    };

    nixosConfigurations.Carbon = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./hosts/Carbon/hardware-configuration.nix
        ./hosts/Carbon/configuration.nix
      ];
    };
  };
}
