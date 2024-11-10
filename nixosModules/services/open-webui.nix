{ pkgs, lib, config, ...}:

let module = config.modules.open-webui;

in {
  options = {
    modules.open-webui.enable = lib.mkEnableOption "enable open-webui";
  };

  config = lib.mkIf module.enable {
    services.open-webui = {
      enable = true;
      port = 7391;
      environmentFile = /home/noah/.webui.env;
    };
  };
}

