#!/usr/bin/env bash
set -e

# Carga conda si no esta inicializado en la shell
for c in "$HOME/miniconda3" "$HOME/anaconda3" "/opt/conda"; do
    if [ -f "$c/etc/profile.d/conda.sh" ]; then
        source "$c/etc/profile.d/conda.sh"
        break
    fi
done

# Activa (o crea) el entorno conda y ejecuta PdfBooklet
ENV_NAME="${ENV_NAME:-pdfbooklet}"

if ! conda env list | grep -q "^${ENV_NAME} "; then
    echo "Creando entorno conda '${ENV_NAME}'..."
    conda create -y -n "${ENV_NAME}" python=3.11
fi

conda activate "${ENV_NAME}"

# Dependencias de sistema via conda-forge
conda install -y -c conda-forge pygobject pycairo gtk3 poppler gobject-introspection >/dev/null 2>&1 || true

# Dependencias Python
pip install -q -r requirements.txt

export PYTHONPATH="$(cd "$(dirname "$0")" && pwd)"
python bin/pdfbooklet
