{
  description = "Custom NixOS WSL build using nixos-24.11";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # Override the nixos-wsl flake’s nixpkgs input to point to nixos-24.11.
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      # Here we override the default nixpkgs input that NixOS-WSL uses.
      inputs.nixpkgs = {
        url = "github:NixOS/nixpkgs/nixos-24.11";
      };

      nixosConfigurations.default.config.imports = [ ./configuration.nix ];
    };
  };

  outputs = { self, nixos-wsl, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in {
      # Build a NixOS configuration using the overridden nixos-wsl
      nixosConfigurations.diracnix = nixos-wsl.nixosConfigurations.default;
    };
}
