{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  myTexlive = with pkgs.texlive; (
    combine {
      inherit (pkgs.texlive)
      scheme-medium latexmk enumitem
      cm-unicode fontawesome
      biblatex biber
      moderncv moderntimeline;
    }
  );
  fontsConf = pkgs.makeFontsConf {
    fontDirectories = [ 
      "${myTexlive}/share/texmf/"
    ];
  };
in
{
  cv = stdenv.mkDerivation {
    name = "cv.pdf";
    buildInputs = [ myTexlive ];
      src = ./.;
      FONTCONFIG_FILE = fontsConf;
      buildPhase = ''
        latexmk -xelatex cv.tex || (cat cv.log >&2 && exit 1)
      '';
      installPhase = ''
        install -m444 cv.pdf $out
      '';
    };
}
