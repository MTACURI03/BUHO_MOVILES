@echo off
echo =====================================
echo   CONFIGURAR FLUTTER - EL BUHO
echo =====================================
echo.

echo Verificando si Flutter esta en C:\flutter...
if exist "C:\flutter\bin\flutter.bat" (
    echo ✓ Flutter encontrado en C:\flutter
) else (
    echo ✗ Flutter no encontrado en C:\flutter
    echo.
    echo Descarga Flutter desde: https://docs.flutter.dev/get-started/install/windows
    echo Extrae el ZIP en C:\flutter
    pause
    exit /b 1
)

echo.
echo Configurando PATH de Flutter...

echo.
echo Agregando Flutter al PATH...
setx PATH "%PATH%;C:\flutter\bin"

echo.
echo =====================================
echo   PROBANDO FLUTTER
echo =====================================
echo.

echo Reiniciando variables de entorno...
call refreshenv 2>nul

echo.
echo Probando Flutter (puede tardar un momento)...
C:\flutter\bin\flutter.bat --version

if %errorlevel% == 0 (
    echo.
    echo ✓ Flutter configurado correctamente
    echo.
    echo Verificando configuracion completa...
    C:\flutter\bin\flutter.bat doctor
) else (
    echo.
    echo ✗ Error configurando Flutter
    echo.
    echo SOLUCION:
    echo 1. Cierra este terminal
    echo 2. Abre un nuevo PowerShell/CMD
    echo 3. Ejecuta: flutter --version
)

echo.
echo =====================================
echo   SIGUIENTE PASO
echo =====================================
echo.
echo Si Flutter funciona correctamente:
echo 1. Cierra este terminal
echo 2. Abre nuevo PowerShell en: C:\Users\PC\Desktop\buho
echo 3. Ejecuta: .\compilar_apk.bat
echo.

pause
