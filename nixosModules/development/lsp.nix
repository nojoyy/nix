{ pkgs, lib, config, ... }:

{

  options = {
    lsp.enable = lib.mkEnableOption "enable lsp";
  };
  
  config = lib.mkIf config.lsp.enable {
    environment.systemPackages = with pkgs; [
      nil # nix language server
      #deno # runtime and supplies lsp
    ];
  };
}
