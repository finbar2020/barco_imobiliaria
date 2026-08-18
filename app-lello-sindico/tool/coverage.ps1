# Gera lcov + HTML de cobertura e abre no navegador.
# Uso (na pasta do app):  powershell -File tool/coverage.ps1
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

Write-Host "Rodando flutter test --coverage..."
flutter test --coverage
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Gerando HTML..."
dart run tool/lcov_to_html.dart coverage/lcov.info coverage/html
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$index = Join-Path (Get-Location) "coverage/html/index.html"
Write-Host "Abrindo $index"
Start-Process $index
