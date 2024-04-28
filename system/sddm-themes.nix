{stdenv, fetchFromGitHub }:

{
  abstractdark = stdenv.mkDerivation rec {
    pname = "abstractdark";
    version = "20161002";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/$pname
    '';
    src = fetchFromGitHub {
      owner = "3ximus";
      repo = "adbstractdark-sddm-theme";
      rev = "e817d4b27981080cd3b398fe928619ffa16c52e7";
      sha256 = "1si141hnp4lr43q36mbl3anlx0a81r8nqlahz3n3l7zmrxb56s2y";
    };
  };
}
