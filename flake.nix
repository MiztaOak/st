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
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          pkg-config
          libX11
          libXft
          fontconfig
          freetype
          harfbuzz
          gcc
          gnumake
        ];

        shellHook = ''
          exec zsh
        '';
      };
    });
}
