{
  description = "Nixos config flake";

  inputs = {

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
    };

    # use latest emacs
    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # declaritive ricing
    stylix.url = "github:danth/stylix"; 
    
    # kernel build process for surface pro
    nixos-hardware.url = "github:tracteurblinde/nixos-hardware/surface-linux-6.8.1";

    # lsp for nix
    nil.url = "github:oxalica/nil";

    # age-encrypted secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # recipe manager app
    recipe-manager = {
      url = "git+https://git.noahjoyner.com/noah/recipe-manager.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # personal website
    site = {
      url = "git+https://git.noahjoyner.com/noah/site.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs,
    home-manager,
    stylix,
    agenix,
    recipe-manager,
    site,
    ...
  }@inputs: 

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

        # hardware specific
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

        # interacts with both home-manager and nix
        stylix.nixosModules.stylix
      ];
      specialArgs = { inherit inputs; };
    };

    nixosConfigurations.Carbon = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = {
        inherit recipe-manager site;
      };
      modules = [
        ./hosts/Carbon/hardware-configuration.nix
        ./hosts/Carbon/configuration.nix

        # Secrets management
        agenix.nixosModules.default
      ];
    };
  };
}
