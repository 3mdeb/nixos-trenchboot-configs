with import <nixpkgs> {};

stdenv.mkDerivation rec {
  pname = "landing-zone";
  version = "0.3.0-gLZ_COMMIT";

  src = ./../../../..;

  patches = [ ./compatibility.patch ];

  nativeBuildInputs = [ hexdump pkgconfig automake gcc-unwrapped ];
  buildInputs = [ libstdcxx5 ];

  meta = with lib; {
    homepage = https://github.com/TrenchBoot/landing-zone;
    description = "Landing Zone";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
