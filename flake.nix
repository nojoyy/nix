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

    emacs-config = {
      url = "git+https://git.noahjoyner.com/noah/emacs.git";
      flake = false;
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
    nixosConfigurations.sapphire = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        # system entrypoints
        ./hosts/sapphire/hardware-configuration.nix
        ./hosts/sapphire/configuration.nix

        # home-manager setup
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noah = import ./hosts/sapphire/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }

        # interacts with both home-manager and nix
        stylix.nixosModules.stylix
      ];
      specialArgs = { inherit inputs; };
    };
    
    nixosConfigurations.ruby = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        # my entrypoints
        ./hosts/ruby/hardware-configuration.nix
        ./hosts/ruby/configuration.nix

        # home-manager setup
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noah = import ./hosts/ruby/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }

        # interacts with both home-manager and nix
        stylix.nixosModules.stylix

        # hardware specific
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
      ];
      specialArgs = { inherit inputs; };
    };

    nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./hosts/carbon/hardware-configuration.nix
        ./hosts/carbon/configuration.nix
      ];
    };
  };
}
