{ lib, config, pkgs, ... }:

let module = config.modules.postgresql;

in {
  options = {
    modules.postgresql.enable = lib.mkEnableOption "enable and set up postgres for development";
  };
  config = lib.mkIf module.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "noah" "recipe_manager_dev" "recipe_manager_test" ];
      ensureUsers = [
        {
          name = config.users.users.noah.name;
          ensureDBOwnership = true;
        }
      ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
        host  all       all     127.0.0.1/32   trust
        host  all       all     ::1/128        trust
      '';
    };
  };
}
