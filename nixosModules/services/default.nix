{ pkgs, lib, config, ... }:

let homeDir = config.users.users."noah".home;

in {
  imports = [
    ./gitea.nix
    ./jellyfin.nix
    ./open-webui.nix
    ./matrix.nix
  ];
}
