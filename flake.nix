{
  description = "My rime data";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        my-rime-data = pkgs.stdenv.mkDerivation {
          name = "my-rime-data";
          src = ./flypy;
          buildPhase = ''
            mkdir -p $out/share/rime-data
            cp -r ./* $out/share/rime-data
            cp -f -r ${./custom}/* $out/share/rime-data
          '';
          installPhase = ''
            # pass
          '';
        };
      in {
        overlays.default = (self: super: {
          rime-data = my-rime-data;
          fcitx5-rime = super.fcitx5-rime.override {
            rime-data = my-rime-data;
            rimeDataPkgs = [ my-rime-data ];
          };
        });
        packages.default = my-rime-data;
      });
}
