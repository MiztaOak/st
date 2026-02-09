{
  description = "simple st flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          (final: prev: {
            st = prev.st.overrideAttrs (old: {
              src = ./.;
              buildInputs = with prev; old.buildInputs ++ [
                harfbuzz 
                nerd-fonts.jetbrains-mono
              ];
            });
          })
        ];
      };
    in {
      packages.default = pkgs.st;
    });
}
