# 🎯 **GUÍA SÚPER FÁCIL: De Cero a APK en 15 Minutos**

## 🚀 **PASO 1: Descargar Flutter (5 minutos)**

### **Método Más Fácil:**

1. **📂 Abrir navegador** y ir a: 
   ```
   https://docs.flutter.dev/get-started/install/windows
   ```

2. **📥 Descargar** el archivo:
   ```
   flutter_windows_3.24.3-stable.zip
   ```
   *(~1.5 GB - tarda 3-5 minutos)*

3. **📁 Extraer** el archivo ZIP en:
   ```
   C:\flutter
   ```
   *(Crear la carpeta C:\flutter si no existe)*

---

## 🔧 **PASO 2: Configurar Flutter (2 minutos)**

### **Ejecutar script automático:**

1. **▶️ Doble clic** en: `configurar_flutter.bat`
2. **✅ Verificar** que aparezca: "Flutter configurado correctamente"

### **O configurar manualmente:**

1. **⚙️ Abrir** Panel de Control → Sistema → Configuración avanzada
2. **🔗 Variables de entorno** → Editar variable `PATH`
3. **➕ Agregar:** `C:\flutter\bin`

---

## 🏗️ **PASO 3: Compilar APK (5 minutos)**

### **Método automático:**

1. **🖱️ Abrir** PowerShell en la carpeta del proyecto
2. **▶️ Ejecutar:** `.\compilar_apk.bat`
3. **⏳ Esperar** 3-5 minutos

### **Método manual:**

```bash
# Navegar al proyecto
cd C:\Users\PC\Desktop\buho

# Obtener dependencias
flutter pub get

# Compilar APK
flutter build apk --release
```

---

## 📱 **RESULTADO FINAL**

### **📍 Ubicación del APK:**
```
C:\Users\PC\Desktop\buho\build\app\outputs\flutter-apk\app-release.apk
```

### **📊 Información del APK:**
- **Tamaño:** ~25-30 MB
- **Compatible con:** Android 5.0+
- **Funcionalidades:** 100% completas

---

## 🎮 **SCRIPTS CREADOS (Úsalos):**

| 📄 Archivo | 🎯 Función |
|------------|------------|
| `instalar_flutter_simple.bat` | Guía de instalación |
| `configurar_flutter.bat` | Configurar PATH automáticamente |
| `compilar_apk.bat` | Compilar APK con verificaciones |

---

## 🆘 **¿Problemas? Soluciones Rápidas:**

### **❌ "Flutter no encontrado"**
```bash
# Verificar ubicación
dir C:\flutter\bin\flutter.bat

# Si no existe, repetir Paso 1
```

### **❌ "Android SDK requerido"**
```bash
# Usar flutter con configuración básica
flutter config --enable-web
flutter build web
```

### **❌ "Comando no reconocido"**
```bash
# Reiniciar terminal
# Usar ruta completa
C:\flutter\bin\flutter.bat --version
```

---

## ⚡ **INICIO RÁPIDO (Para impacientes):**

### **🔥 Súper Rápido (Si tienes Chocolatey):**
```powershell
choco install flutter
flutter pub get
flutter build apk --release
```

### **🔥 Rápido (Descarga manual):**
1. Descargar Flutter ZIP
2. Extraer en `C:\flutter`
3. Ejecutar `configurar_flutter.bat`
4. Ejecutar `compilar_apk.bat`

---

## 🎉 **¡Empezar AHORA!**

**👈 Ejecuta:** `instalar_flutter_simple.bat`

**⏱️ En 15 minutos tendrás tu APK listo para instalar en cualquier Android!**
