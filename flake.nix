{
  description = "virtual environments";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell = let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            makeWrapper
            python2 # skia-bindings
            python3 # rust-xcb
            llvmPackages.clang # skia
            removeReferencesTo

            cargo
            rustc
            cmake
            wayland
          ];
          packages = with pkgs; [
            SDL2

            openssl
            (fontconfig.overrideAttrs (old: {
              propagatedBuildInputs = [
                # skia is not compatible with freetype 2.11.0
                (freetype.overrideAttrs (old: rec {
                  version = "2.10.4";
                  src = fetchurl {
                    url = "mirror://savannah/${old.pname}/${old.pname}-${version}.tar.xz";
                    sha256 = "112pyy215chg7f7fmp2l9374chhhpihbh8wgpj5nj6avj3c59a46";
                  };
                }))
              ];
            }))
          ];
        };
    });
}
