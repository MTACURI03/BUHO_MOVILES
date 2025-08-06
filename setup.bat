@echo off
echo =====================================
echo   CONFIGURACION EL BUHO TURISMO
echo =====================================
echo.

echo Verificando Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter no esta instalado o no esta en PATH
    echo.
    echo Instala Flutter desde: https://docs.flutter.dev/get-started/install/windows
    echo Luego agrega flutter/bin a las variables de entorno PATH
    pause
    exit /b 1
)

echo.
echo Instalando dependencias...
flutter pub get

echo.
echo Verificando configuracion...
flutter doctor

echo.
echo =====================================
echo   CONFIGURACION COMPLETADA
echo =====================================
echo.
echo PROXIMOS PASOS:
echo 1. Configurar Firebase siguiendo firebase_setup.md
echo 2. Agregar google-services.json en android/app/
echo 3. Ejecutar: flutter run
echo.
echo Para compilar APK: flutter build apk --release
echo.
pause
