@echo off
:: ============================================================================
:: Regera o relatorio de analise (assets/analysis.json).
:: Duplo clique no Explorer ou execute pelo terminal — funciona nos dois casos.
:: ============================================================================
setlocal EnableExtensions
pushd "%~dp0"

echo.
echo ============================================================
echo  Projetos - regenerando analise arquitetural
echo ============================================================
echo  Pasta: %CD%
echo.

where dart >nul 2>nul
if errorlevel 1 (
  echo [ERRO] O executavel "dart" nao esta no PATH.
  echo Instale o Flutter/Dart e tente novamente.
  goto :end
)

dart run tool/analyze_projects.dart %*
set EXITCODE=%ERRORLEVEL%

echo.
if %EXITCODE% NEQ 0 (
  echo [FALHOU] codigo de saida %EXITCODE%
) else (
  echo [OK] assets\analysis.json foi atualizado.
  echo Se o app estiver aberto no navegador, de um refresh na aba.
)

:end
popd
echo.
pause
endlocal
