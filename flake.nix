{
  description = "MEMU";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    self,
    zig-overlay,
    nixpkgs,
    flake-utils,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [zig-overlay.overlays.default];
        };
        riscvPkgs = import nixpkgs {
          localSystem = "${system}";
          crossSystem = {
            config = "riscv64-unknown-linux-gnu";
            abi = "lp64";
          };
        };
        deps = with pkgs; [
          git
          gnumake
          zigpkgs.master
          pkgsCross.riscv64-embedded.buildPackages.gcc
        ];
      in {
        legacyPackages = pkgs;
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell.override {stdenv = pkgs.clangStdenv;} {
          buildInputs = [deps riscvPkgs.buildPackages.gcc] ++ pkgs.lib.optional pkgs.stdenv.isLinux riscvPkgs.buildPackages.gdb;
          RV64_TOOLCHAIN_ROOT = "${pkgs.pkgsCross.riscv64-embedded.buildPackages.gcc}";
          shellHook = ''
            export EMU_CC=$RV64_TOOLCHAIN_ROOT/bin/riscv64-unknown-linux-gnu-gcc
            export EMU_OBJCOPY=$RV64_TOOLCHAIN_ROOT/bin/riscv64-unknown-linux-gnu-objcopy
            make test-img
            unset EMU_CC
            unset EMU_OBJCOPY
          '';
        };
      }
    )
    // {inherit inputs;};
}
