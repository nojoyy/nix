{ pkgs, lib, config, recipe-manager ? null, ... }:

{
  imports = [
    # ./gitea.nix
    ./jellyfin.nix
    ./open-webui.nix
    ./matrix.nix
    # ./shiori.nix
    ./postgres.nix
    ./recipe-manager.nix
  ];
}
