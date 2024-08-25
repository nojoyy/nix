{pkgs, lib, config, ... }:

{

  options = {
    js-dev.enable = lib.mkEnableOption "enable node and other core js things";
    # js-dev.lsp.enable = lib.mkEnableOption "enable lsp for js/ts"; #TODO figure out how to implement this
  };
  config = lib.mkIf config.js-dev.enable {
      environment.systemPackages = with pkgs; [
	eslint_d
        nodejs
        deno
	nodePackages.typescript-language-server
	nodePackages.prettier
        bruno # for debugging http requests
        chromium # for testing alongside gecko
      ];
  };
}

