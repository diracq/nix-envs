{
  description = "Custom NixOS WSL build using nixos-24.11";

  inputs = {
    # Override the nixos-wsl flake’s nixpkgs input to point to nixos-24.11.
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      # Here we override the default nixpkgs input that NixOS-WSL uses.
      inputs.nixpkgs = {
        url = "github:NixOS/nixpkgs/nixos-24.11";
      };
    };
  };

  outputs = { self, nixos-wsl, ... }:
    let
      system = "x86_64-linux";
    in {
      # Build a NixOS configuration using the overridden nixos-wsl
      nixosConfigurations.diracnix = nixos-wsl.lib.nixosSystem {
        system = system;
        modules = [
          nixos-wsl.nixosModules.default
          # You can add further customizations here (e.g. install extra packages)
        ];
      };
    };
}

