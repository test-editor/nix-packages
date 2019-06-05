{ stdenv, bash, findutils, fetchurl }:

stdenv.mkDerivation rec {
    name = "firefox_67_0";
    version = "67.0";
    src = fetchurl {
      url = "http://ftp.mozilla.org/pub/firefox/releases/67.0/linux-x86_64/en-US/firefox-67.0.tar.bz2";
      sha256 = "c0d5d05c0dbc78e9f1b1bbc2166f1dca6f37067a4b1412743d8bdacdc9ca1117";
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
