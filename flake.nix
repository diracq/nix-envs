{
  description = "Custom NixOS WSL build using nixos-24.11";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # follow the up to date nixpkgs version
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixos-wsl,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      setupScript = pkgs.writers.writePython3Bin "diracsetup" {
        libraries = with pkgs.python312Packages; [
          gitpython
          termcolor
        ];
      } (builtins.readFile ./setupscript.py);
    in
    {
      nixosConfigurations.wsl = nixos-wsl.nixosConfigurations.default;

      apps.${system}.default = {
        type = "app";
        program = "${setupScript}/bin/diracsetup";
      };
    };
}
