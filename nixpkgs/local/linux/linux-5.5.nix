{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.5.3";
  modDirVersion = version;

  src = ./linux-sl-5.5.tar.gz;

  # branchVersion needs to be x.y
  extraMeta.branch = 5.5;

  kernelPatches = [];

extraConfig = ''
            SECURE_LAUNCH y
            SECURE_LAUNCH_SHA256 y
'';


} // (args.argsOverride or {}))

