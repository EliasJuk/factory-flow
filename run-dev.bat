@echo off
setlocal

:menu
cls
echo ========================================
echo           FactoryFlow
echo ========================================
echo.
echo  1 - App (Flutter)
echo  2 - Docker
echo  3 - Backend
echo  0 - Sair
echo.

set /p OPCAO=Escolha uma opcao: 

if "%OPCAO%"=="1" (
  call app\scripts\run-dev.bat
  goto menu
)

if "%OPCAO%"=="2" (
  if exist docker\scripts\run-dev.bat (
    call docker\scripts\run-dev.bat
  ) else (
    echo.
    echo Docker ainda nao configurado.
    pause
  )
  goto menu
)

if "%OPCAO%"=="3" (
  if exist backend\scripts\run-dev.bat (
    call backend\scripts\run-dev.bat
  ) else (
    echo.
    echo Backend ainda nao configurado.
    pause
  )
  goto menu
)

if "%OPCAO%"=="0" (
  exit /b
)

echo.
echo Opcao invalida.
pause
goto menu