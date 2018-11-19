{ stdenv, bash, coreutils, findutils, gawk, gnugrep, nix, fetchurl,
  glibcLocales, pkgconfig, gnutar, gzip, zlib, glib, glibc, setJavaClassPath, libxslt, libxml2, libX11, libXrender, libXaw, libXext, libXt, libXtst, libXi, libXinerama, libXcursor, libXrandr, alsaLib, fontconfig, freetype }:

stdenv.mkDerivation rec {
  name = "openjdk_10_0_2";
  version = "10.0.2";
  src = fetchurl {
    url = "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz";
    sha256 = "f3b26abc9990a0b8929781310e14a339a7542adfd6596afb842fa0dd7e3848b2";
  };
  buildInputs = [ glibcLocales pkgconfig gnutar gzip zlib stdenv.cc.libc glib setJavaClassPath libxslt libxml2 libX11 libXrender libXaw libXext libXt libXtst libXi libXinerama libXcursor libXrandr alsaLib fontconfig freetype ];
  installPhase = ''
    mkdir -p $out
    cp -r ./* "$out/"
    # correct interpreter and rpath for binaries to work
    rpath="${stdenv.lib.makeLibraryPath [ glibcLocales pkgconfig gnutar gzip zlib stdenv.cc.libc glib setJavaClassPath libxslt libxml2 libX11 libXext libXrender libXaw libXt libXtst libXi libXinerama libXcursor libXrandr alsaLib fontconfig freetype ]}:$out/lib/jli:$out/lib/server:$out/lib"
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;
    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs
    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    export JAVA_HOME=$out
    EOF
  '';
  meta = with stdenv.lib; {
    description = "OpenJDK 10.0.2, open-source build of the Java Development";
    homepage = https://jdk.java.net/10/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
