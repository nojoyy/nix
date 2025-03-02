{pkgs, lib, config, ... }:

let module = config.modules.js-dev;

in {
  options = {
    modules.js-dev.enable = lib.mkEnableOption "enable js-development helpers (linting, lsp, etc)";
  };
  config = lib.mkIf module.enable {
      environment.systemPackages = with pkgs; [
	eslint_d
	nodePackages.typescript-language-server
	nodePackages.prettier
        bruno # for debugging http requests
        chromium # for testing alongside gecko
      ];
  };
}

