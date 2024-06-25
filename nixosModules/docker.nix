{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.noah.extraGroups = [ "docker" ];
}
