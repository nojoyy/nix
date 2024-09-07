{ pkgs, lib, config, ... }:

let module = config.modules.lsp;

in {
  options = {
    modules.lsp.enable = lib.mkEnableOption "enable lsp";
  };
  
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      nil # nix language server
      #deno # runtime and supplies lsp
    ];
  };
}
