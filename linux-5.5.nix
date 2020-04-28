{ pkgs, ... }:

{
  boot.kernelPackages = let
      linux_sgx_pkg = { fetchurl, buildLinux, ... } @ args:

        buildLinux (args // rec {
          version = "5.5.3";
          modDirVersion = version;
          src = builtins.fetchGit {
            url = "https://github.com/TrenchBoot/linux.git";
            ref = "linux-sl-5.5";
            rev = "eed5cdf480ee3761d18294d64ac7e2184229b51c";
          };


          # branchVersion needs to be x.y
          extraMeta.branch = 5.5;

          kernelPatches = [];

          extraConfig = ''
            SECURE_LAUNCH y
            SECURE_LAUNCH_SHA256 y
'';

      } // (args.argsOverride or {}));
      linux_sgx = pkgs.callPackage linux_sgx_pkg{};
    in
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_sgx);
}
