{ pkgs, config, lib, ... }:

let
  inherit (lib) types;
  
  cfg = config.grub;

in
{
  
  options = {
    grub = {
      enable = lib.mkEnableOption "grub bootloader";
      useOSProber = lib.mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to check for other installed OS";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      grub = {
        enable = true;
        devices = [ "nodev" ];
        useOSProber = cfg.useOSProber;
        efiSupport = cfg.useOSProber;
      };
    };
  };
}
      
