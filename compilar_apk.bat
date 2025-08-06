@echo off
echo =====================================
echo   COMPILAR APK - EL BUHO TURISMO
echo =====================================
echo.

echo Verificando Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter no encontrado
    echo.
    echo Ejecuta primero: instalar_flutter.bat
    pause
    exit /b 1
)

echo.
echo Verificando proyecto...
if not exist "pubspec.yaml" (
    echo ERROR: No estas en el directorio del proyecto
    echo Navega a: C:\Users\PC\Desktop\buho
    pause
    exit /b 1
)

echo.
echo PASO 1: Limpiar proyecto
echo ========================
flutter clean

echo.
echo PASO 2: Obtener dependencias
echo ===========================
flutter pub get

echo.
echo PASO 3: Verificar configuracion
echo ==============================
flutter doctor

echo.
echo PASO 4: Compilar APK
echo ===================
echo.

echo IMPORTANTE: Para que funcione completamente necesitas:
echo 1. Configurar Firebase (opcional para probar UI)
echo 2. Archivo google-services.json (opcional)
echo.

set /p compile="¿Continuar con la compilacion? (s/n): "

if /i "%compile%"=="s" (
    echo.
    echo Compilando APK de release...
    flutter build apk --release
    
    if %errorlevel% == 0 (
        echo.
        echo =====================================
        echo        APK COMPILADO EXITOSAMENTE
        echo =====================================
        echo.
        echo Ubicacion del APK:
        echo build\app\outputs\flutter-apk\app-release.apk
        echo.
        echo Tamaño aproximado: ~20-30 MB
        echo.
        
        if exist "build\app\outputs\flutter-apk\app-release.apk" (
            for %%A in ("build\app\outputs\flutter-apk\app-release.apk") do echo Tamaño real: %%~zA bytes
            echo.
            echo ¿Quieres abrir la carpeta del APK?
            set /p open="(s/n): "
            if /i "!open!"=="s" (
                start "" "build\app\outputs\flutter-apk\"
            )
        )
    ) else (
        echo.
        echo ERROR en la compilacion
        echo.
        echo Posibles soluciones:
        echo 1. Ejecutar: flutter doctor
        echo 2. Instalar Android SDK
        echo 3. Configurar licencias: flutter doctor --android-licenses
    )
) else (
    echo Compilacion cancelada
)

echo.
pause
