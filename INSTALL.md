# El Búho - Aplicación de Turismo

## Instalación de Flutter

Para compilar y ejecutar esta aplicación, necesitas instalar Flutter:

### Opción 1: Instalación manual
1. Descargar Flutter desde: https://docs.flutter.dev/get-started/install/windows
2. Extraer en una carpeta (ej: C:\flutter)
3. Agregar C:\flutter\bin a las variables de entorno PATH
4. Ejecutar `flutter doctor` para verificar la instalación

### Opción 2: Usando Git
```bash
git clone https://github.com/flutter/flutter.git -b stable
```

## Configuración del Proyecto

1. **Instalar dependencias:**
```bash
flutter pub get
```

2. **Configurar Firebase:**
   - Seguir las instrucciones en `firebase_setup.md`
   - Agregar `google-services.json` en `android/app/`

3. **Verificar configuración:**
```bash
flutter doctor
```

## Comandos de Desarrollo

### Ejecutar en modo desarrollo
```bash
flutter run
```

### Ejecutar en dispositivo específico
```bash
flutter devices
flutter run -d [device_id]
```

### Compilar APK de producción
```bash
flutter build apk --release
```

### Limpiar build
```bash
flutter clean
flutter pub get
```

## Estructura del Proyecto

```
lib/
├── main.dart              # Punto de entrada
├── models/               # Modelos de datos
│   ├── user.dart
│   ├── tourist_site.dart
│   └── review.dart
├── screens/              # Pantallas de la app
│   ├── auth/            # Autenticación
│   ├── home/            # Pantalla principal
│   ├── sites/           # Sitios turísticos
│   └── profile/         # Perfil de usuario
├── services/            # Servicios de Firebase
│   ├── auth_service.dart
│   ├── tourist_site_service.dart
│   └── review_service.dart
├── widgets/             # Componentes reutilizables
└── utils/              # Utilidades y constantes
```

## Características Implementadas

✅ **Autenticación**
- Registro de usuarios
- Inicio de sesión
- Perfiles de Visitante y Publicador

✅ **Sitios Turísticos**
- Listado de sitios
- Detalle con galería de imágenes
- Publicación de nuevos sitios (solo Publicadores)
- Subida de hasta 5 fotografías

✅ **Sistema de Reseñas**
- Escribir reseñas con calificación
- Ver reseñas de otros usuarios
- Sistema de respuestas

✅ **Gestión de Imágenes**
- Selección desde galería
- Captura con cámara
- Validación de tamaño y formato

## Requisitos del Sistema

- **Flutter SDK:** >=3.0.0
- **Dart SDK:** >=3.0.0
- **Android SDK:** API 21+ (Android 5.0+)
- **Conexión a Internet** para Firebase

## Compilación del APK

El APK compilado se encontrará en:
`build/app/outputs/flutter-apk/app-release.apk`

## Solución de Problemas

### Error: Flutter command not found
```bash
# Verificar PATH
echo $PATH

# Agregar Flutter al PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Error: Android SDK not found
```bash
flutter config --android-sdk /path/to/android/sdk
```

### Error: Google Services
- Verificar que `google-services.json` esté en `android/app/`
- Verificar configuración en Firebase Console

## Contacto

Para soporte técnico o preguntas sobre el desarrollo, contactar al equipo de El Búho.
