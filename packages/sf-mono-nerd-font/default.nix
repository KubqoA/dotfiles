#TODO: do my own patching
{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "SF-Mono-Nerd-Font";
  pname = "SF-Mono-Nerd-Font";
  version = "v15.0d5e1";

  src = fetchFromGitHub {
    owner = "epk";
    repo = pname;
    rev = version;
    sha256 = "IkTbd5qpWue9utkCVHTvPSHnrVLBU3OQ9BqorNU7yQk=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/SF\ Mono\ Nerd\ Font
    cp -a SFMono*.otf $out/share/fonts/opentype/SF\ Mono\ Nerd\ Font
  '';
}
