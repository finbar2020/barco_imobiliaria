# Gera lcov + HTML de cobertura e abre no navegador.
# Uso (na pasta do app):  powershell -File tool/coverage.ps1
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

Write-Host "Rodando flutter test --coverage..."
flutter test --coverage
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Gerando HTML bruto (referência)..."
dart run tool/lcov_to_html.dart coverage/lcov.info coverage/html-raw

Write-Host "Filtrando lcov (escopo testável)..."
dart run tool/filter_lcov.dart coverage/lcov.info coverage/lcov.filtered.info
dart run tool/lcov_to_html.dart coverage/lcov.filtered.info coverage/html
dart run tool/lcov_to_html.dart coverage/lcov.filtered.info coverage/html-filtered
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$index = Join-Path (Get-Location) "coverage/html/index.html"
Write-Host "Abrindo $index (escopo testável — ver html-raw/ para bruto)"
Start-Process $index
