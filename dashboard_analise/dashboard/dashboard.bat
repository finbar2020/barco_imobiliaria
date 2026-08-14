@echo off
:: ============================================================================
:: Regera o relatorio E abre o dashboard no Chrome (flutter run).
:: Para parar, aperte Ctrl+C nesta janela.
:: ============================================================================
setlocal EnableExtensions
pushd "%~dp0"

echo.
echo ============================================================
echo  Projetos - regenerando analise + abrindo dashboard
echo ============================================================
echo.

where dart >nul 2>nul
if errorlevel 1 (
  echo [ERRO] "dart" nao esta no PATH.
  goto :end
)
where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERRO] "flutter" nao esta no PATH.
  goto :end
)

echo [1/2] Regenerando analise...
dart run tool/analyze_projects.dart
if errorlevel 1 (
  echo [FALHOU] analise falhou. Nao vou abrir o dashboard.
  goto :end
)

echo.
echo [2/2] Abrindo dashboard no Chrome...
echo (aperte Ctrl+C nesta janela para encerrar)
echo.
flutter run -d chrome

:end
popd
echo.
pause
endlocal
