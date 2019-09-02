{ stdenv, bash, findutils, fetchurl }:

stdenv.mkDerivation rec {
    name = "firefox_62_0_3";
    version = "62.0.3";
    src = if stdenv.isDarwin
    then fetchurl {
      url = "http://ftp.mozilla.org/pub/firefox/releases/62.0.3/mac/en-US/Firefox%2062.0.3.dmg";
      sha256 = "fcd04d8695d48fa11b59f2cf49f2888f41d9c9c0eb0754da07b4d438ce442d51";
    } else fetchurl {
      url = "http://ftp.mozilla.org/pub/firefox/releases/62.0.3/linux-x86_64/en-US/firefox-62.0.3.tar.bz2";
      sha256 = "dafff4bd8b45d82f861c2e7215963461ed8333d75534defe677c3deefb2b3aa2";
    };

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* "$out/bin/"
    # correct interpreter and rpath for binaries to work
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \;
   '';
  meta = with stdenv.lib; {
    description = "Mozilla Firefox 62.0.3";
    homepage = https://www.mozilla.org/en-US/firefox/;
    license = licenses.mpl20;
    platforms = platforms.linux;
  };
}
