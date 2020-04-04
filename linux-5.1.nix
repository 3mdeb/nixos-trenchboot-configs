{ pkgs, ... }:

{
  boot.kernelPackages = let
      linux_sgx_pkg = { fetchurl, buildLinux, ... } @ args:

        buildLinux (args // rec {
          version = "5.1.0";
          modDirVersion = version;
          src = builtins.fetchGit {
            url = "https://github.com/3mdeb/linux-stable.git";
            ref = "linux-sl-5.1-sha2-amd";
            rev = "6821d9b40e9ac9bbd6bac1a5963a87cd6ea735bc";
          };


          # branchVersion needs to be x.y
          extraMeta.branch = 5.1;

          kernelPatches = [];

          extraConfig = import ./tb-config.nix;

      } // (args.argsOverride or {}));
      linux_sgx = pkgs.callPackage linux_sgx_pkg{};
    in
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_sgx);
}
