#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
VERSION="2.35.4"
BASE="https://github.com/simolus3/drift/releases/download/drift-${VERSION}"
curl --fail --location --show-error "$BASE/sqlite3.wasm" --output web/sqlite3.wasm
curl --fail --location --show-error "$BASE/drift_worker.js" --output web/drift_worker.dart.js
python3 - <<'PYVALIDATE'
from pathlib import Path
wasm = Path('web/sqlite3.wasm').read_bytes()
worker = Path('web/drift_worker.dart.js').read_bytes()
if not wasm.startswith(b'\x00asm'):
    raise SystemExit('Error: sqlite3.wasm no es un archivo WebAssembly valido.')
if len(worker) < 1000 or b'<html' in worker[:500].lower():
    raise SystemExit('Error: el archivo worker no es JavaScript valido.')
print('SQLite Web: archivos descargados y verificados.')
PYVALIDATE
