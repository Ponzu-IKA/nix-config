{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
  wayland,
  xorg,
  libxkbcommon,
  libGL,
}:

rustPlatform.buildRustPackage rec {
  pname = "noita_entangled_worlds";
  version = "v0.32.6";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = pname;
    rev = version;
    hash = "sha256-fpj4vBhMws3o3Gs/hq94+ITd4AtuKoVHnAlt/PWwLIU=";
  };

  sourceRoot = "source/noita-proxy";
  cargoHash = "sha256-AMnI0mvSuEDRPolcBgR6aCXaiRgMn1qpWjlksLjhvwQ=";

  # tests fail due to no internet
  doCheck = false;

  nativeBuildInputs = [ python3 ];
  buildInputs = [
    libxkbcommon
    libGL

    # WINIT_UNIX_BACKEND=wayland
    wayland

    # WINIT_UNIX_BACKEND=x11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
  ];

  postInstall = ''
    mkdir -p $out/lib
    cp $src/redist/libsteam_api.so $out/lib/libsteam_api.so
  '';

  postFixup = ''
    patchelf --add-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/noita-proxy
  '';
  meta = {
    description = "Noita Co-op multiplayer mod";
    homepage = "https://github.com/IntQuant/noita_entangled_worlds";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
