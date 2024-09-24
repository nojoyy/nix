{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, disko, ...}: {
    nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
