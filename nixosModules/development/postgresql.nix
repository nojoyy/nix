{ lib, config, pkgs, ... }:

let module = config.modules.postgresql;

in {
  options = {
    modules.postgresql.enable = lib.mkEnableOption "enable and set up postgres for development";
  };
  config = lib.mkIf module.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "mydatabase" ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';
    };
  };
}
