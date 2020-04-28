with import <nixpkgs> {};

stdenv.mkDerivation rec {
  pname = "landing-zone";
  version = "0.3.0";

  src = builtins.fetchGit {
  url = "https://github.com/TrenchBoot/landing-zone.git";
  ref = "master";
  rev = "89fc4113166823268b07d27f8b13d82223a2361d";
  };

  patches = [ ./compatibility.patch ];

  nativeBuildInputs = [ hexdump pkgconfig automake gcc-unwrapped ];
  buildInputs = [ libstdcxx5 ];

  meta = with lib; {
    homepage = https://github.com/TrenchBoot/landing-zone;
    description = "Landing Zone";
    license = licenses.gpl2;
    platforms = platforms.all;
  };

  makeFlags = [ "DEBUG=y" ];

}
