{pkgs, lib, config, ... }:

let module = config.modules.csharp;

in {
  options = {
    modules.csharp.enable = lib.mkEnableOption "enable node and other core js things";
  };

  config = lib.mkIf module.enable {
      environment.systemPackages = with pkgs; [
        omnisharp-roslyn
      ];
  };
}
