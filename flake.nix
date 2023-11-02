{
  description = "lib-extras / A collection of extra (maybe opinionated) functions to nixpkgs.lib!";

  inputs = {
    # pkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-root.url = "github:srid/flake-root";

    # utils
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = ["x86_64-linux"];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        # devshell
        devshells.default = {
          name = "lib-extras";
          commands = [
            {
              name = "check";
              category = "Checks";
              help = "Checks the source code";
              command = "nix flake check";
            }
            {
              name = "fmt";
              category = "Formatters";
              help = "Format the source tree";
              command = ''nix fmt'';
            }
          ];
        };

        # treefmt
        treefmt.config = {
          inherit (config.flake-root) projectRootFile;
          package = pkgs.treefmt;
          flakeFormatter = true;
          flakeCheck = true;
          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            mdformat.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;
          };
        };
      };
    }
    // {
      lib = import ./src/lib.nix;
    };
}
