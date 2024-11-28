{ lib
, pkgs
, buildPythonPackage
, pytestCheckHook
, tree-sitter
  # `name`: grammar derivation pname in the format of `tree-sitter-<lang>`
, name
, grammarDrv
}:
let
  inherit (grammarDrv) version src;

  snakeCaseName = lib.replaceStrings [ "-" ] [ "_" ] name;
  drvPrefix = "python-${name}";
in
buildPythonPackage {
  inherit version src;
  pname = drvPrefix;

  preBuild = ''
    ${lib.getExe pkgs.eza} --tree /
    '';

  # tree-sitter test needs a writable home folder for tests.
  preCheck = ''
    HOME=. ${lib.getExe pkgs.tree-sitter} test
  '';

  nativeCheckInputs = [ tree-sitter pytestCheckHook ];
  pythonImportsCheck = [ snakeCaseName ];

  meta = {
    description = "Python bindings for ${name}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-jay98 adfaure mightyiam stepbrobd ];
  };
}
