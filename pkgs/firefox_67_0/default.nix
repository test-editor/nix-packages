{ stdenv, bash, findutils, fetchurl }:

stdenv.mkDerivation rec {
    name = "firefox_67_0";
    version = "67.0";
    src = fetchurl {
      url = "http://ftp.mozilla.org/pub/firefox/releases/62.0/linux-x86_64/en-US/firefox-67.0.tar.bz2";
      sha256 = "3c5adf71d655c0ec68c7a8d431a080a0c3aca2e2cc615d4d9bbfc574785b14cd";
    };

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* "$out/bin/"
    # correct interpreter and rpath for binaries to work
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \;
   '';
  meta = with stdenv.lib; {
    description = "Mozilla Firefox 67.0";
    homepage = https://www.mozilla.org/en-US/firefox/;
    license = licenses.mpl20;
    platforms = platforms.linux;
  };
}
