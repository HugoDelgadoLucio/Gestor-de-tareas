$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
$version = '2.35.4'
$base = "https://github.com/simolus3/drift/releases/download/drift-$version"
Invoke-WebRequest -Uri "$base/sqlite3.wasm" -OutFile 'web/sqlite3.wasm'
Invoke-WebRequest -Uri "$base/drift_worker.js" -OutFile 'web/drift_worker.dart.js'
$bytes = [System.IO.File]::ReadAllBytes((Join-Path (Get-Location) 'web/sqlite3.wasm'))
if ($bytes.Length -lt 4 -or $bytes[0] -ne 0 -or $bytes[1] -ne 97 -or $bytes[2] -ne 115 -or $bytes[3] -ne 109) {
    throw 'El archivo sqlite3.wasm descargado no es WebAssembly valido.'
}
if ((Get-Item 'web/drift_worker.dart.js').Length -lt 1000) {
    throw 'El archivo worker descargado parece incompleto.'
}
Write-Host 'SQLite Web: archivos descargados y verificados.'
