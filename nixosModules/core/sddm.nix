{ config, pkgs, lib, ... }:

let
  
  buildTheme = { name, version, src, themeIni ? [] }:
    pkgs.stdenv.mkDerivation rec {
      pname = "sddm-theme-${name}";
      inherit version src;

      buildCommand = ''
      dir=$out/share/sddm/themes/${name}
      doc=$out/share/doc/${pname}

      mkdir -p $dir $doc
      if [ -d $src/${name} ]; then
        srcDir=$src/${name}
      else
        srcDir=$src
      fi

      cp -r $srcDir/* $dir/
      for f in $dir/{AUTHORS,COPYING,LICENSE,README,*.md,*.txt}; do
        test -f $f && mv $f $doc/
      done
      chmod 644 $dir/theme.conf

      ${lib.concatMapStringsSep "\n" (e: ''
        ${pkgs.crudini}/bin/crudini --set --inplace $dir/theme.conf \
          "${e.section}" "${e.key}" "${e.value}"
      '') themeIni}
    '';
    };

  customTheme = builtins.isAttrs theme;
  theme = themes.abstractdark;

  themeName = if customTheme
              then theme.pkg.name
              else theme;

  packages = if customTheme
             then [ (buildTheme theme.pkg) ] ++ theme.deps
             else [];

  themes = {
    # https://github.com/3ximus/abstractdark-sddm-theme
    abstractdark = {
      pkg = rec {
        name = "abstractdark";
        version = "20161002";
        src = pkgs.fetchFromGitHub {
          owner = "3ximus";
          repo = "abstractdark-sddm-theme";
          rev = "e817d4b27981080cd3b398fe928619ffa16c52e7";
          hash = "sha256-XmhTVs/1Hzrs+FBRbFEOSIFOrRp0VTPwIJmSa2EgIeo=";
        };
      };
        deps = with pkgs; [];
    };

      # https://gitlab.com/isseigx/simplicity-sddm-theme
      simplicity = {
        pkg = rec { 
          name = "simplicity";
          version = "0.3.2";
          src = pkgs.fetchFromGitLab {
            owner = "isseigx";
            repo = "simplicity-sddm-theme";
            rev = "836cf153cd03d04c4f9795a1c5e9748c06860805";
            hash = "sha256-QDHnCgbCzRd0Ma559xtwOwzkQ/6Yj9zuCjFuFStcshM=";
          };
        };
        deps = with pkgs; [];
      };
  };

  module = config.modules.sddm;

in {

  options = {
    modules.sddm.enable = lib.mkEnableOption "enable sddm";
  };

  config = lib.mkIf module.enable {
    # Install declared theme derivations
    environment.systemPackages = packages;

    # Enable and configure SDDM
    services.displayManager.sddm = {
      wayland.enable = true;
      enable = true;
      enableHidpi = true;
      autoNumlock = true;
      theme = themeName;
    };
  };
}
    
