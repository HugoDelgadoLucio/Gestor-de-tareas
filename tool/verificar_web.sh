#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
from pathlib import Path
import sys
wasm = Path('web/sqlite3.wasm')
worker = Path('web/drift_worker.dart.js')
issues = []
if not wasm.is_file():
    issues.append('Falta web/sqlite3.wasm')
elif not wasm.read_bytes().startswith(b'\x00asm'):
    issues.append('web/sqlite3.wasm no es un archivo WebAssembly válido')
if not worker.is_file():
    issues.append('Falta web/drift_worker.dart.js')
elif worker.stat().st_size < 1000 or b'<html' in worker.read_bytes()[:500].lower():
    issues.append('web/drift_worker.dart.js no parece ser JavaScript válido')
if issues:
    for issue in issues:
        print(issue)
    sys.exit(1)
print('Archivos web encontrados y formato básico verificado.')
print('La compatibilidad de versiones y los encabezados HTTP deben comprobarse aparte.')
PY
