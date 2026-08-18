# Sobe o SonarQube local (Docker) e envia o lcov gerado pelo coverage.ps1.
# Pré-requisitos: Docker, sonar-scanner no PATH, coverage/lcov.info já gerado.
# Login padrão do Sonar: admin / admin
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Host "Docker não encontrado. Use o HTML em coverage/html/index.html para acompanhar a cobertura."
  Write-Host "No PC com Docker: docker compose -f docker-compose.sonar.yml up -d"
  exit 1
}

docker compose -f docker-compose.sonar.yml up -d
Write-Host "Aguardando Sonar em http://localhost:9000 ..."
$ready = $false
for ($i = 0; $i -lt 60; $i++) {
  try {
    $r = Invoke-WebRequest -Uri "http://localhost:9000/api/system/status" -UseBasicParsing -TimeoutSec 3
    if ($r.Content -match "UP") { $ready = $true; break }
  } catch { }
  Start-Sleep -Seconds 5
}
if (-not $ready) {
  Write-Host "Sonar ainda não respondeu. Abra http://localhost:9000 e rode de novo."
  exit 1
}

if (-not (Test-Path "coverage/lcov.info")) {
  Write-Host "coverage/lcov.info ausente. Rode tool/coverage.ps1 primeiro."
  exit 1
}

if (-not (Get-Command sonar-scanner -ErrorAction SilentlyContinue)) {
  Write-Host "sonar-scanner não está no PATH. Instale o SonarScanner e rode:"
  Write-Host "  sonar-scanner"
  exit 1
}

sonar-scanner
Write-Host "Pronto: http://localhost:9000/dashboard?id=app-lello-sindico"
