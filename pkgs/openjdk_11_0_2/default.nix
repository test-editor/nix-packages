{ stdenv, bash, coreutils, findutils, gawk, gnugrep, nix, fetchurl, patchelf,
  glibcLocales, pkgconfig, gnutar, gzip, zlib, glib, glibc, setJavaClassPath, libxslt, libxml2, libX11, libXrender, libXaw, libXext, libXt, libXtst, libXi, libXinerama, libXcursor, libXrandr, fontconfig, freetype }:

stdenv.mkDerivation rec {
  name = "openjdk_11_0_2";
  version = "11.0.2";
  sha256_linux = "99be79935354f5c0df1ad293620ea36d13f48ec3ea870c838f20c504c9668b57";
  sha256_osx   = "f365750d4be6111be8a62feda24e265d97536712bc51783162982b8ad96a70ee";

  platform = if stdenv.isDarwin then "osx" else "linux";
  hash = if stdenv.isDarwin then sha256_osx else sha256_linux;

  src = fetchurl {
    url = "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_${platform}-x64_bin.tar.gz";
    sha256 = hash;
  };
  buildInputs = [ glibcLocales pkgconfig gnutar gzip zlib stdenv.cc.libc glib setJavaClassPath libxslt libxml2 libX11 libXrender libXaw libXext libXt libXtst libXi libXinerama libXcursor libXrandr fontconfig freetype patchelf ];
  installPhase = ''
    mkdir -p $out

    if [ "${platform}" == "osx" ]; then
      cp -r ./Contents/Home/* "$out/"

    elif [ "${platform}" == "linux" ]; then
      cp -r ./* "$out/"

      # correct interpreter and rpath for binaries to work
      rpath="${stdenv.lib.makeLibraryPath [ glibcLocales pkgconfig gnutar gzip zlib stdenv.cc.libc glib setJavaClassPath libxslt libxml2 libX11 libXext libXrender libXaw libXt libXtst libXi libXinerama libXcursor libXrandr fontconfig freetype ]}:$out/lib/jli:$out/lib/server:$out/lib"
      find $out -type f -perm -0100 \
          -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "$rpath" {} \;
      find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;
    fi

    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs
    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    export JAVA_HOME=$out
    EOF
  '';

  meta = with stdenv.lib; {
    description = "OpenJDK 11.0.2, open-source build of the Java Development";
    homepage = https://jdk.java.net/archive/;
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
