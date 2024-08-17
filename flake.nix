{
  description = "DankNil's Nix Env(dnenv)";
  inputs = {
    # nixpkgs unstable repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # System list
    systems.url = "github:nix-systems/default";
  };
  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    inherit (self) outputs;

    forAllSystems = nixpkgs.lib.genAttrs (import systems);

    lib =
      nixpkgs.lib.extend
      (final: prev: (import ./lib final));
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # TODO: shell setup
    devShells = forAllSystems (system: {});
  };
}
