{ pkgs, config, lib, ... }:

let module = config.modules.services.matrix;

in {
  options = {
    modules.services.matrix.enable = lib.mkEnableOption "enable dendrite - matrix homeserver";
  };

  config = lib.mkIf module.enable {
    services.dendrite = {
      enable = true;
      domain = "matrix.noahjoyner.com";
      database = {
        connectionString = "file:/var/lib/dendrite/dendrite.db"; # SQLite for simplicity.
      };
      enableMetrics = true;
      listeners = [
        {
          type = "http";
          bind = "127.0.0.1:8008"; # Client API listener.
        }
        {
          type = "http";
          bind = "0.0.0.0:8448";
        }
      ];
    };
  };
}
