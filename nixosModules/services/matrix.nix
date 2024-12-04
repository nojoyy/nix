{ pkgs, config, lib, ... }:

let module = config.modules.matrix;

in {
  options = {
    modules.matrix.enable = lib.mkEnableOption "enable dendrite - matrix homeserver";
  };

  config = lib.mkIf module.enable {
    services.dendrite = {
      enable = true;
      settings = {
        global = {
          server_name = "matrix.noahjoyner.com";
          database = {
            connection_string = "file:/var/lib/dendrite/dendrite.db"; # SQLite for simplicity.
          };
          private_key = "/home/noah/matrix_key.pem";
        };
      };
    };
  };
}
