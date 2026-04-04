{
  description = "Shakthi Sangita Sabha development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, git-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            check-merge-conflicts.enable = true;
            check-toml.enable = true;
            check-yaml.enable = true;
            detect-private-keys.enable = true;
            end-of-file-fixer.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        };

      in
      {
        checks = {
          inherit pre-commit;
        };

        devShells.default = pkgs.mkShell {
          name = "shakthisangitasabha";

          packages = [
            pkgs.git
            pkgs.go
            pkgs.hugo
            pkgs.dart-sass
            pkgs.wrangler
          ];

          shellHook = ''
            ${pre-commit.shellHook}
          '';
        };
      }
    ) // {
      garnix = {
        builds = {
          exclude = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
        };
      };
    };
}
