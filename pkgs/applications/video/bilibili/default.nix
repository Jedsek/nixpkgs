{ stdenv
, fetchurl
, electron
, lib
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "bilibili";
  version = "1.9.2-1";
  src = fetchurl {
    url = "https://github.com/msojocs/bilibili-linux/releases/download/v${version}/io.github.msojocs.bilibili_${version}_amd64.deb";
    sha256 = "sha256-y3dUBImvcIG89m82RaIOa0cxJXIAIGa+n3FJkASacaY=";
  };

  unpackPhase = ''
    ar x $src
    tar xf data.tar.xz
  '';

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/share $out/share
    sed -i "s|Exec=.*|Exec=$out/bin/bilibili|" $out/share/applications/*.desktop
    cp -r opt/apps/io.github.msojocs.bilibili/files/bin/app $out/opt
    makeWrapper ${electron}/bin/electron $out/bin/bilibili \
      --argv0 "bilibili" \
      --add-flags "$out/opt/app.asar"
  '';

  meta = with lib; {
    description = "bilibili client in linux, based on electron";
    homepage = "https://github.com/msojocs/bilibili-linux";
    license = licenses.mit;
    maintainers = with maintainers; [ jedsek ];
    platforms = platforms.unix;
  };  
}
