{ pkgs }:

pkgs.writeShellScriptBin "diracsetup" ''
  echo "Hello from nix run!"
''