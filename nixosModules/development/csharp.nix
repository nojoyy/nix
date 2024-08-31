{pkgs, lib, config, ... }:

{
  options = {
    csharp.enable = lib.mkEnableOption "enable node and other core js things";
  };

  config = lib.mkIf config.csharp.enable{
      environment.systemPackages = with pkgs; [
        omnisharp-roslyn
      ];
  };
}
