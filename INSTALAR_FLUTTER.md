# 🚀 GUÍA RÁPIDA: Instalación Flutter y Compilación APK

## 📋 **OPCIÓN 1: Instalación Automática (FÁCIL)**

### **Paso 1: Ejecutar Script de Instalación**
```bash
# Hacer clic derecho en "instalar_flutter.bat" → "Ejecutar como administrador"
.\instalar_flutter.bat
```

### **Paso 2: Compilar APK**
```bash
# Después de instalar Flutter, ejecutar:
.\compilar_apk.bat
```

---

## 📋 **OPCIÓN 2: Instalación Manual (PASO A PASO)**

### **1️⃣ Descargar Flutter**
1. **Ir a:** https://docs.flutter.dev/get-started/install/windows
2. **Descargar:** `flutter_windows_3.24.3-stable.zip` (~1.5 GB)
3. **Extraer en:** `C:\flutter`

### **2️⃣ Configurar PATH**
1. **Abrir:** Panel de Control → Sistema → Configuración avanzada
2. **Variables de entorno** → Variable del sistema `PATH`
3. **Agregar:** `C:\flutter\bin`

### **3️⃣ Instalar Android SDK**
1. **Descargar:** Android Command Line Tools
2. **URL:** https://developer.android.com/studio#command-tools
3. **Extraer en:** `C:\Android\Sdk\cmdline-tools`
4. **Agregar al PATH:** 
   - `C:\Android\Sdk\cmdline-tools\latest\bin`
   - `C:\Android\Sdk\platform-tools`

### **4️⃣ Configurar Android**
```bash
# Aceptar licencias
flutter doctor --android-licenses

# Verificar instalación
flutter doctor
```

### **5️⃣ Compilar APK**
```bash
cd C:\Users\PC\Desktop\buho
flutter pub get
flutter build apk --release
```

---

## ⚡ **OPCIÓN 3: Instalación Ultra Rápida (5 minutos)**

### **Usando Chocolatey:**
```powershell
# Instalar Chocolatey (si no tienes)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Instalar Flutter
choco install flutter

# Verificar
flutter doctor
```

---

## 🎯 **RESULTADO FINAL**

Después de cualquier opción, tendrás:

📱 **APK Ubicación:**
```
C:\Users\PC\Desktop\buho\build\app\outputs\flutter-apk\app-release.apk
```

📊 **Características del APK:**
- **Tamaño:** ~25-30 MB
- **Versión Android:** API 21+ (Android 5.0+)
- **Arquitectura:** ARM64, ARM32, x86_64

---

## 🔧 **Scripts Creados para Ti:**

| Script | Función |
|--------|---------|
| `instalar_flutter.bat` | Instala Flutter automáticamente |
| `compilar_apk.bat` | Compila el APK paso a paso |
| `setup.bat` | Configuración general |

---

## 🚨 **Solución de Problemas Comunes**

### **Error: Flutter no encontrado**
```bash
# Verificar PATH
echo %PATH%

# Agregar manualmente
setx PATH "%PATH%;C:\flutter\bin"
```

### **Error: Android SDK no encontrado**
```bash
flutter config --android-sdk C:\Android\Sdk
```

### **Error: Licencias Android**
```bash
flutter doctor --android-licenses
# Presionar 'y' para todo
```

---

## ⏱️ **Tiempo Estimado:**

- **Descarga Flutter:** 10-15 minutos
- **Configuración:** 5 minutos  
- **Compilación APK:** 3-5 minutos
- **TOTAL:** ~20-25 minutos

---

## 🎉 **¡Empezar Ahora!**

**Opción más fácil:** Ejecutar `instalar_flutter.bat` como administrador

**¿Necesitas ayuda?** Todos los scripts tienen mensajes detallados de ayuda.
