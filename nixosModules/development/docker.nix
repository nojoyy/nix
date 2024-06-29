{ pkgs, lib, config, ... }:

{
  options = {
    docker.enable = lib.mkEnableOption "enable docker";
  };

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    users.users.noah.extraGroups = [ "docker" ];
  };
}
