@echo off
echo =====================================
echo   INSTALACION FLUTTER SIMPLIFICADA
echo =====================================
echo.

echo OPCION 1: DESCARGA MANUAL (MAS FACIL)
echo ====================================
echo.
echo 1. Abre tu navegador
echo 2. Ve a: https://docs.flutter.dev/get-started/install/windows
echo 3. Descarga: flutter_windows_3.24.3-stable.zip
echo 4. Extrae en: C:\flutter
echo 5. Ejecuta: configurar_flutter.bat
echo.

echo OPCION 2: USAR CHOCOLATEY (RAPIDO)
echo =================================
echo.
echo Si tienes Chocolatey instalado:
echo choco install flutter
echo.

echo OPCION 3: USAR WINGET (WINDOWS 11)
echo =================================
echo.
echo winget install --id Git.Git
echo winget install --id Google.Flutter
echo.

echo =====================================
echo.

set /p choice="¿Que opcion prefieres? (1/2/3): "

if "%choice%"=="1" (
    echo.
    echo Abriendo pagina de descarga de Flutter...
    start https://docs.flutter.dev/get-started/install/windows
    echo.
    echo INSTRUCCIONES:
    echo 1. Descarga el archivo ZIP
    echo 2. Extrae en C:\flutter
    echo 3. Ejecuta: configurar_flutter.bat
) else if "%choice%"=="2" (
    echo.
    echo Instalando Flutter con Chocolatey...
    choco install flutter
) else if "%choice%"=="3" (
    echo.
    echo Instalando Flutter con winget...
    winget install --id Google.Flutter
) else (
    echo Opcion no valida
)

echo.
pause
