{
  description = "Shakthi Sangita Sabha development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "shakthisangitasabha";

          buildInputs = with pkgs; [
            go
            hugo
            nodejs
            wrangler
          ];

          shellHook = ''
            export PATH="$PATH:$PWD/node_modules/.bin"
          '';
        };
      });
}
