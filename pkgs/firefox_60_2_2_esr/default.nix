{ stdenv, bash, findutils, fetchurl }:

stdenv.mkDerivation rec {
    name = "firefox_60_esr";
    version = "60.2.2esr";
    src = fetchurl {
      url = http://ftp.mozilla.org/pub/firefox/releases/60.2.2esr/linux-x86_64/en-US/firefox-60.2.2esr.tar.bz2;
      sha256 = "71ac702c25e654c04ee61ddd5a394ae52e27886beeed7d575542e3fe7e8e4939";
    };

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* "$out/bin/"
    # correct interpreter and rpath for binaries to work
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \;
   '';
  meta = with stdenv.lib; {
    description = "Mozilla Firefox 60.2.2esr";
    homepage = https://www.mozilla.org/en-US/firefox/;
    license = licenses.mpl20;
    platforms = platforms.linux;
  };
}
