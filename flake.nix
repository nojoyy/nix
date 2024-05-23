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
          ./home/default.nix
          inputs.hyprland.homeManagerModules.default
          ./modules/hyprland.nix
          ./modules/pcmanfm.nix
          ./modules/obs.nix
        ];
      };
      
      "noah@Ruby" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home/Ruby.nix
          ./home/default.nix
          inputs.hyprland.homeManagerModules.default
          ./modules/hyprland.nix
          ./modules/pcmanfm.nix
        ];
      };
    };
    
    # Nixos configurations
    nixosConfigurations.Sapphire = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      modules = [
        ./hardware/Sapphire.nix
        ./system/default.nix
        inputs.stylix.nixosModules.stylix
        ./system/Sapphire.nix
        ./system/locale.nix
        ./home/users/noah.nix
        ./system/carbon.nix
	      ./system/graphical.nix
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
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ./system/default.nix
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
