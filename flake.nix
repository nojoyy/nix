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
    nixosConfigurations.Sapphire = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./system/Sapphire.nix
        ./hardware/Sapphire.nix
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noah = import ./home/Sapphire.nix;
        }
      ];
      specialArgs = { inherit inputs; };
    };
    
    nixosConfigurations.Ruby = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./system/Ruby.nix
        ./hardware/Ruby.nix
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noah = import ./home/Ruby.nix;
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
