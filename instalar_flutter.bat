@echo off
echo =====================================
echo   INSTALACION FLUTTER - EL BUHO
echo =====================================
echo.

echo Este script te ayudara a instalar Flutter paso a paso
echo.

echo PASO 1: DESCARGAR FLUTTER
echo =========================
echo.
echo Opcion 1 - Descarga Manual (RECOMENDADO):
echo 1. Abre tu navegador
echo 2. Ve a: https://docs.flutter.dev/get-started/install/windows
echo 3. Descarga "flutter_windows_3.24.3-stable.zip"
echo 4. Extrae el archivo en C:\flutter
echo.

echo Opcion 2 - Descarga Automatica:
echo.
set /p choice="¿Quieres que descargue Flutter automaticamente? (s/n): "

if /i "%choice%"=="s" (
    echo Descargando Flutter...
    powershell -Command "Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip' -OutFile 'C:\flutter.zip'"
    
    if exist "C:\flutter.zip" (
        echo Extrayendo Flutter...
        powershell -Command "Expand-Archive -Path 'C:\flutter.zip' -DestinationPath 'C:\' -Force"
        echo Flutter descargado y extraido en C:\flutter
    ) else (
        echo Error al descargar. Usa la opcion manual.
        goto manual
    )
) else (
    :manual
    echo.
    echo INSTRUCCIONES MANUALES:
    echo 1. Abre https://docs.flutter.dev/get-started/install/windows
    echo 2. Descarga el ZIP de Flutter
    echo 3. Extrae en C:\flutter
    echo 4. Ejecuta este script de nuevo
    pause
    exit /b 1
)

echo.
echo PASO 2: CONFIGURAR PATH
echo =====================
echo.

echo Agregando Flutter al PATH del sistema...
setx PATH "%PATH%;C:\flutter\bin" /M

echo.
echo PASO 3: VERIFICAR INSTALACION
echo ============================
echo.

echo Verificando Flutter...
C:\flutter\bin\flutter.bat doctor

echo.
echo PASO 4: CONFIGURAR ANDROID
echo =========================
echo.

echo Descargando Android SDK...
set /p android="¿Quieres descargar Android SDK automaticamente? (s/n): "

if /i "%android%"=="s" (
    echo Descargando Android Command Line Tools...
    powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip' -OutFile 'C:\android-tools.zip'"
    
    if exist "C:\android-tools.zip" (
        echo Extrayendo Android Tools...
        mkdir "C:\Android\Sdk\cmdline-tools" 2>nul
        powershell -Command "Expand-Archive -Path 'C:\android-tools.zip' -DestinationPath 'C:\Android\Sdk\cmdline-tools' -Force"
        
        echo Configurando Android SDK...
        setx ANDROID_HOME "C:\Android\Sdk" /M
        setx PATH "%PATH%;C:\Android\Sdk\cmdline-tools\cmdline-tools\bin;C:\Android\Sdk\platform-tools" /M
        
        echo Aceptando licencias de Android...
        echo y | C:\Android\Sdk\cmdline-tools\cmdline-tools\bin\sdkmanager.bat --licenses
        
        echo Instalando herramientas de Android...
        C:\Android\Sdk\cmdline-tools\cmdline-tools\bin\sdkmanager.bat "platform-tools" "platforms;android-33" "build-tools;33.0.0"
    )
)

echo.
echo =====================================
echo   INSTALACION COMPLETADA
echo =====================================
echo.

echo SIGUIENTE PASO:
echo 1. Reinicia tu terminal/PowerShell
echo 2. Ejecuta: flutter doctor
echo 3. Si todo esta OK, ejecuta: compilar_apk.bat
echo.

pause
