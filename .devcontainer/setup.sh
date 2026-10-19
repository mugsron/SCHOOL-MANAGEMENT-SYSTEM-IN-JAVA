#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
from pathlib import Path
import zipfile
root = Path.cwd()
if not (root / 'smart-campus').exists():
    with zipfile.ZipFile('smart-campus.zip') as archive:
        for name in archive.namelist():
            if not (root / name).resolve().is_relative_to(root):
                raise SystemExit('Unsafe archive entry')
        archive.extractall(root)
PY
cd smart-campus
mvn -B -ntp verify
printf '\nReady. Start the app with: bash .devcontainer/start.sh (from the repository root)\n'
