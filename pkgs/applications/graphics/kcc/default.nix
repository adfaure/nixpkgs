{ lib
, mkDerivationWith
, python3
, python3Packages
, fetchPypi
, fetchFromGitHub
, p7zip
, archiveSupport ? true
, cmake
, mozjpeg
}:
mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "kcc";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "ciromattia";
    repo = "kcc";
    rev = "refs/tags/v${version}";
    hash = "sha256-61P4rsPRUJVrqv0xegxohRu7Yr8goSk7ElFV37GAYe8=";
  };

  nativeBuildInputs = with python3Packages; [
    pip
  ];

  propagatedBuildInputs = with python3Packages ; [
    p7zip
    pillow
    pyqt5
    psutil
    python-slugify
    raven
    requests
    natsort
    mozjpeg_lossless_optimization
    distro
    pyside6
  ];

  qtWrapperArgs = lib.optionals archiveSupport [ "--prefix" "PATH" ":" "${ lib.makeBinPath [ p7zip ] }" ];

  postFixup = ''
    wrapProgram $out/bin/kcc "''${qtWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "Python app to convert comic/manga files or folders to EPUB, Panel View MOBI or E-Ink optimized CBZ";
    homepage = "https://kcc.iosphe.re";
    license = licenses.isc;
    maintainers = with maintainers; [ dawidsowa adfaure ];
  };
}
