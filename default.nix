{
  lib,
  stdenv,
  python3,
  gtk3,
  poppler_gi,
  gsettings-desktop-schemas,
  gobject-introspection,
  wrapGAppsHook3,
  makeWrapper,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    pygobject3
    pycairo
    pikepdf
    img2pdf
    python-dateutil
    packaging
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pdfbooklet";
  version = "3.1.6";

  src = ./.;

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    gtk3
    poppler_gi
    gsettings-desktop-schemas
  ];

  # The app hardcodes a Debian-style prefix; point it at the store instead.
  strictDeps = false;
  # We wrap the launcher by hand in postFixup (gappsWrapperArgs is only
  # populated by the hook during preFixup, i.e. after installPhase).
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pdfbooklet
    cp -r pdfbooklet $out/share/pdfbooklet/pdfbooklet
    cp -r pdfbooklet/data $out/share/pdfbooklet/data
    cp -r documentation $out/share/pdfbooklet/documentation
    cp -r locale $out/share/pdfbooklet/locale
    cp -r bin $out/share/pdfbooklet/bin

    substituteInPlace $out/share/pdfbooklet/pdfbooklet/pdfbooklet3.py \
      --replace-fail '"/usr/share/pdfbooklet"' '"'"$out"'/share/pdfbooklet"' \
      --replace-fail '"/usr/share/pdfbooklet/documentation"' '"'"$out"'/share/pdfbooklet/documentation"'

    install -Dm644 pdfbooklet/data/pdfbooklet.desktop \
      $out/share/applications/pdfbooklet.desktop
    substituteInPlace $out/share/applications/pdfbooklet.desktop \
      --replace-fail 'Exec=pdfbooklet' "Exec=$out/bin/pdfbooklet"

    for size in 48 256; do
      install -Dm644 pdfbooklet/data/pdfbooklet.png \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/pdfbooklet.png"
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${pythonEnv}/bin/python3 $out/bin/pdfbooklet \
      --add-flags "$out/share/pdfbooklet/bin/pdfbooklet" \
      --prefix PYTHONPATH : "$out/share/pdfbooklet" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Create booklets and other layouts from PDF files";
    homepage = "https://github.com/TomasResquin/PdfBooklet";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "pdfbooklet";
  };
})
