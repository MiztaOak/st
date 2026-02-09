{
  description = "simple st flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { flake-parts, ... } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "x86_64-linux"
    ];
    perSystem = { system, ...}: {
      _module.args.pkgs = import inputs.nixpgs {
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
        config = { };
      };
    };
  };
}
