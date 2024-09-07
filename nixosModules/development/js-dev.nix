{pkgs, lib, config, ... }:

let module = config.modules.js-dev;

in {
  options = {
    modules.js-dev.enable = lib.mkEnableOption "enable node and other core js things";
    # js-dev.lsp.enable = lib.mkEnableOption "enable lsp for js/ts"; #TODO figure out how to implement this
  };
  config = lib.mkIf module.enable {
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

