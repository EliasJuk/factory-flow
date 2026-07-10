@echo off
setlocal EnableDelayedExpansion
title Gerenciador de Setup Flutter
REM O script fica em nome-do-projeto\scripts\
REM A raiz do projeto Flutter fica uma pasta acima.
cd /d "%~dp0.."

:: ============================================================
::
::   1 - Setup inicial do Flutter (verifica/instala o SDK)
::   2 - Remover setup do Flutter (desinstala o SDK)
::   3 - Iniciar projeto Flutter (pergunta o nome e cria o projeto
::       Windows Desktop nesta pasta)
::   4 - Executar projeto Flutter (Windows)
::   5 - Executar projeto Flutter (Chrome)
::   6 - Build do projeto Flutter (Windows Release)
::   7 - Abrir App Compilado (.exe)
::
:: O SDK e instalado em C:\flutter - facilita limpar o ambiente.
::
:: ============================================================

for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "RED=%ESC%[91m"
set "CYAN=%ESC%[96m"
set "RESET=%ESC%[0m"

set "FLUTTER_DIR=C:\flutter"

:menu
cls
echo %CYAN%========================================%RESET%
echo %CYAN%  Gerenciador de Setup Flutter%RESET%
echo %CYAN%========================================%RESET%
echo.
echo   1 - Setup inicial do Flutter
echo   2 - Remover setup do Flutter
echo   3 - Iniciar projeto Flutter
echo   4 - Executar projeto (Windows)
echo   5 - Executar projeto (Chrome)
echo   6 - Build do projeto (Windows)
echo   7 - Abrir App Compilado (.exe)
echo   0 - Sair
echo.
set "OPCAO="
set /p "OPCAO=Escolha uma opcao: "

if "%OPCAO%"=="1" goto :setup
if "%OPCAO%"=="2" goto :remove
if "%OPCAO%"=="3" goto :criar_projeto
if "%OPCAO%"=="4" goto :rodar_windows
if "%OPCAO%"=="5" goto :rodar_chrome
if "%OPCAO%"=="6" goto :build_windows
if "%OPCAO%"=="7" goto :abrir_build
if "%OPCAO%"=="0" goto :fim

echo.
echo %RED%[ERRO]%RESET% Opcao invalida.
pause
goto :menu


:: ============================================================
:: 1 - SETUP INICIAL
:: ============================================================
:setup
echo.
echo %CYAN%--- Setup inicial do Flutter ---%RESET%
echo.

where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
	echo %GREEN%[OK]%RESET% Flutter ja esta instalado e disponivel no PATH.
	goto :doctor
)

echo %YELLOW%[AVISO]%RESET% Flutter nao encontrado no PATH.
echo.

where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo %RED%[ERRO]%RESET% Git nao encontrado. Instale antes de continuar:
	echo         https://git-scm.com/download/win
	pause
	goto :menu
)
echo %GREEN%[OK]%RESET% Git encontrado.
echo.

if exist "%FLUTTER_DIR%\bin\flutter.bat" (
	echo %GREEN%[OK]%RESET% SDK do Flutter ja existe em %FLUTTER_DIR%
) else (
	echo Baixando o Flutter SDK ^(canal stable^) em %FLUTTER_DIR% ...
	git clone https://github.com/flutter/flutter.git -b stable "%FLUTTER_DIR%"
	if !ERRORLEVEL! NEQ 0 (
		echo %RED%[ERRO]%RESET% Falha ao clonar o Flutter. Verifique sua conexao e tente novamente.
		pause
		goto :menu
	)
	echo %GREEN%[OK]%RESET% Flutter SDK baixado com sucesso.
)
echo.

:: setx trunca o PATH em 1024 caracteres, por isso usamos PowerShell aqui
echo Adicionando %FLUTTER_DIR%\bin ao PATH do usuario ^(permanente^)...
powershell -NoProfile -Command "$p = [Environment]::GetEnvironmentVariable('Path','User'); if ($p -notlike '*%FLUTTER_DIR%\bin*') { [Environment]::SetEnvironmentVariable('Path', '%FLUTTER_DIR%\bin;' + $p, 'User'); Write-Host '[OK] PATH atualizado.' -ForegroundColor Green } else { Write-Host '[OK] PATH ja continha o Flutter.' -ForegroundColor Green }"

set "PATH=%FLUTTER_DIR%\bin;%PATH%"

:doctor
echo.
echo %CYAN%--- flutter doctor -v ---%RESET%
echo.
flutter doctor -v
echo.
echo %YELLOW%Itens de Android/iOS podem ficar com [x], sem problema.%RESET%
echo %YELLOW%O que precisa estar OK: "Windows Version" e%RESET%
echo %YELLOW%"Visual Studio - develop Windows apps".%RESET%
echo.
pause
goto :menu


:: ============================================================
:: 2 - REMOVER SETUP
:: ============================================================
:remove
echo.
echo %CYAN%--- Remover setup do Flutter ---%RESET%
echo.

if not exist "%FLUTTER_DIR%" (
	echo %YELLOW%[AVISO]%RESET% Nada encontrado em %FLUTTER_DIR%. Nao ha o que remover.
	pause
	goto :menu
)

set "CONFIRMA="
set /p "CONFIRMA=Isso vai apagar %FLUTTER_DIR% e remover do PATH. Confirma? (S/N): "
if /I not "%CONFIRMA%"=="S" (
	echo Cancelado.
	pause
	goto :menu
)

echo Removendo %FLUTTER_DIR% ...
rmdir /s /q "%FLUTTER_DIR%"
if exist "%FLUTTER_DIR%" (
	echo %RED%[ERRO]%RESET% Nao foi possivel apagar a pasta. Feche terminais/editores que estejam usando o Flutter e tente de novo.
	pause
	goto :menu
)
echo %GREEN%[OK]%RESET% Pasta removida.

echo Removendo %FLUTTER_DIR%\bin do PATH do usuario...
powershell -NoProfile -Command "$p = [Environment]::GetEnvironmentVariable('Path','User'); $parts = $p -split ';' | Where-Object { $_ -and ($_.TrimEnd('\') -ne '%FLUTTER_DIR%\bin'.TrimEnd('\')) }; [Environment]::SetEnvironmentVariable('Path', ($parts -join ';'), 'User')"
echo %GREEN%[OK]%RESET% PATH atualizado.

echo.
echo Setup do Flutter removido com sucesso.
pause
goto :menu


:: ============================================================
:: 3 - INICIAR PROJETO
:: ============================================================
:criar_projeto
echo.
echo %CYAN%--- Iniciar projeto Flutter ---%RESET%
echo.

where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	if exist "%FLUTTER_DIR%\bin\flutter.bat" (
		set "PATH=%FLUTTER_DIR%\bin;%PATH%"
	) else (
		echo %RED%[ERRO]%RESET% Flutter nao esta instalado. Rode a opcao 1 primeiro.
		pause
		goto :menu
	)
)

:pedir_nome
set "PROJETO="
set /p "PROJETO=Nome do projeto (minusculo, so letras/numeros/underscore, ex: my_app): "

if "%PROJETO%"=="" (
	echo %RED%[ERRO]%RESET% Nome nao pode ser vazio.
	goto :pedir_nome
)

echo %PROJETO%| findstr /r "^[a-z][a-z0-9_]*$" >nul
if %ERRORLEVEL% NEQ 0 (
	echo %RED%[ERRO]%RESET% Nome invalido. Use apenas letras minusculas, numeros e underscore, comecando com letra.
	goto :pedir_nome
)

echo.
echo O projeto sera criado nesta pasta ^(%CD%^), com alvo Windows Desktop.
set "CONFIRMA="
set /p "CONFIRMA=Confirma a criacao do projeto '%PROJETO%'? (S/N): "
if /I not "%CONFIRMA%"=="S" (
	echo Cancelado.
	pause
	goto :menu
)

flutter create --platforms=windows --project-name %PROJETO% .
if %ERRORLEVEL% NEQ 0 (
	echo %RED%[ERRO]%RESET% Falha ao criar o projeto. Veja a mensagem acima.
	pause
	goto :menu
)

echo.
echo %GREEN%[OK]%RESET% Projeto '%PROJETO%' criado com sucesso.
echo Para rodar, use a opcao 4 do menu.
echo.
pause
goto :menu


:: ============================================================
:: 4 - EXECUTAR PROJETO (WINDOWS)
:: ============================================================
:rodar_windows
echo.
echo %CYAN%--- Executar projeto Flutter (Windows) ---%RESET%
echo.

if not exist "pubspec.yaml" (
	echo %RED%[ERRO]%RESET% Arquivo pubspec.yaml nao encontrado.
	echo Certifique-se de estar dentro da pasta do projeto Flutter.
	pause
	goto :menu
)

:: Garante que o Flutter esta no PATH atual
if exist "%FLUTTER_DIR%\bin\flutter.bat" set "PATH=%FLUTTER_DIR%\bin;%PATH%"

echo Iniciando o aplicativo para Windows...
flutter run -d windows
if %ERRORLEVEL% NEQ 0 (
	echo.
	echo %RED%[ERRO]%RESET% Falha ao executar o projeto. Verifique as mensagens de erro acima.
)
echo.
pause
goto :menu


:: ============================================================
:: 5 - EXECUTAR PROJETO (CHROME)
:: ============================================================
:rodar_chrome
echo.
echo %CYAN%--- Executar projeto Flutter (Chrome) ---%RESET%
echo.

if not exist "pubspec.yaml" (
	echo %RED%[ERRO]%RESET% Arquivo pubspec.yaml nao encontrado.
	echo Certifique-se de estar dentro da pasta do projeto Flutter.
	pause
	goto :menu
)

:: Garante que o Flutter esta no PATH atual
if exist "%FLUTTER_DIR%\bin\flutter.bat" set "PATH=%FLUTTER_DIR%\bin;%PATH%"

echo Iniciando o aplicativo no Google Chrome...
flutter run -d chrome
if %ERRORLEVEL% NEQ 0 (
	echo.
	echo %RED%[ERRO]%RESET% Falha ao executar o projeto. Verifique as mensagens de erro acima.
)
echo.
pause
goto :menu


:: ============================================================
:: 6 - BUILD DO PROJETO (WINDOWS)
:: ============================================================
:build_windows
echo.
echo %CYAN%--- Build do projeto Flutter (Windows Release) ---%RESET%
echo.

if not exist "pubspec.yaml" (
	echo %RED%[ERRO]%RESET% Arquivo pubspec.yaml nao encontrado.
	echo Certifique-se de estar dentro da pasta do projeto Flutter.
	pause
	goto :menu
)

:: Garante que o Flutter esta no PATH atual
if exist "%FLUTTER_DIR%\bin\flutter.bat" set "PATH=%FLUTTER_DIR%\bin;%PATH%"

set "CONFIRMA="
set /p "CONFIRMA=Deseja gerar o executavel final (.exe)? (S/N): "
if /I not "%CONFIRMA%"=="S" (
	echo Cancelado.
	pause
	goto :menu
)

echo.
echo Compilando o aplicativo... isso pode demorar um pouco.
flutter build windows

if %ERRORLEVEL% NEQ 0 (
	echo.
	echo %RED%[ERRO]%RESET% Falha ao compilar o projeto. Verifique as mensagens de erro acima.
) else (
	echo.
	echo %GREEN%[OK]%RESET% Build concluido com sucesso!
	echo O executavel e os arquivos necessarios estao em:
	echo %YELLOW%build\windows\x64\runner\Release%RESET%
)
echo.
pause
goto :menu


:: ============================================================
:: 7 - ABRIR APP COMPILADO (.EXE)
:: ============================================================
:abrir_build
echo.
echo %CYAN%--- Abrir App Compilado (.exe) ---%RESET%
echo.

if not exist "build\windows\x64\runner\Release\*.exe" (
	echo %RED%[ERRO]%RESET% Nenhum arquivo .exe encontrado.
	echo Certifique-se de ter rodado a opcao 6 ^(Build^) primeiro.
	pause
	goto :menu
)

:: Procura pelo executavel e o inicia em segundo plano
for %%I in ("build\windows\x64\runner\Release\*.exe") do (
	echo Iniciando o aplicativo: %YELLOW%%%~nxI%RESET% ...
	start "" "%%~fI"
	goto :app_lancado
)

:app_lancado
echo.
echo %GREEN%[OK]%RESET% Aplicativo aberto com sucesso!
pause
goto :menu


:fim
endlocal
exit /b 0