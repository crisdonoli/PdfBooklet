# -*- mode: python3 -*-
# -*- coding: utf8 -*- 

import os
import sys
from PyInstaller.utils.hooks import collect_data_files, collect_submodules

block_cipher = None

# 1. Le préfixe du venv (pour les scripts)
venv_prefix = sys.prefix 

# 2. Le préfixe de MSYS2 (là où sont les DLLs et Typelibs)
# On remonte généralement de quelques niveaux depuis le venv pour trouver /mingw64
# ou on le définit en dur pour être certain :
msys_prefix = "C:/Prog2/msys64b/mingw64" 

# Chemins de recherche corrigés
typelib_path = os.path.join(msys_prefix, 'lib', 'girepository-1.0')
bin_path = os.path.join(msys_prefix, 'bin')

missing_files = []

# Collecte des typelibs avec le bon chemin 
for tl in ["GdkPixbuf-2.0.typelib", "GModule-2.0.typelib", "Poppler-0.18.typelib", "GioWin32-2.0.typelib"]:
    source = os.path.join(typelib_path, tl)
    if os.path.exists(source):
        missing_files.append((source, "gi_typelibs"))
    else:
        print(f"ATTENTION: {source} non trouvé !")

# Collecte des DLLs depuis le dossier bin de MSYS2 
dlls = ["libpoppler-glib-8.dll", "libstdc++-6.dll", "libopenjp2-7.dll", "libcairo-2.dll"]
for dll in dlls:
    source_dll = os.path.join(bin_path, dll)
    if os.path.exists(source_dll):
        missing_files.append((source_dll, "."))



# 2. DÃ©finition des donnÃ©es applicatives
datafiles = [("./test.pdf", "."), 
            ("./pdfbooklet/data", "data"),
            ("./pdfbooklet/PyPDF2_G", "PyPDF2_G")] 

a = Analysis(
    ['pdfbooklet/pdfbooklet3.py'],
    pathex=[os.path.join(venv_prefix, 'Scripts'), 
            './pdfbooklet'], 
    binaries=missing_files,            
    datas=datafiles,
    hiddenimports=['gi', 'keyboard', 'PyPDF2_G'], # On force ces import 
    hookspath=[],
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher) 

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='pdfbooklet',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True, # Gardez True pour le debug, passez Ã  False une fois que tout fonctionne
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='pdfbooklet/data/pdfbooklet.ico'
) 

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='pdfbooklet',
    contents_directory='.'
) 