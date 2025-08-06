# 🦉 El Búho - Aplicación de Turismo Ciudadano

Una aplicación móvil Flutter para turismo ciudadano que permite a los usuarios descubrir, publicar y reseñar sitios turísticos locales.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

## 📱 Descripción

**El Búho** es una plataforma móvil que conecta a turistas y locales para compartir experiencias sobre lugares de interés turístico. Los usuarios pueden descubrir nuevos sitios, compartir sus propios hallazgos y contribuir con reseñas auténticas de la comunidad.

## ✨ Características Principales

### 🔐 **Sistema de Autenticación**
- Registro e inicio de sesión seguro con Supabase Auth
- Autenticación por correo electrónico y contraseña
- Gestión de sesiones persistentes con JWT

### 👥 **Perfiles de Usuario**

#### 🚶‍♀️ **Visitante**
- Explorar sitios turísticos publicados
- Leer reseñas y calificaciones
- Navegar por contenido de la comunidad
- Buscar sitios por categorías

#### ✍️ **Publicador**
- Todas las funciones de Visitante
- Publicar nuevos sitios turísticos
- Subir hasta 5 fotografías por sitio
- Escribir descripciones detalladas
- Gestionar sus publicaciones
- Responder a reseñas de sus sitios

### 📸 **Gestión de Contenido**
- **Fotografías**: Subida desde cámara o galería
- **Validación**: Máximo 5 imágenes por sitio
- **Optimización**: Compresión automática de imágenes
- **Almacenamiento**: Seguro en Supabase Storage

### ⭐ **Sistema de Reseñas**
- Calificaciones de 1 a 5 estrellas
- Comentarios detallados
- Respuestas del publicador
- Moderación de contenido

### 🗺️ **Exploración de Sitios**
- Lista completa de sitios turísticos
- Detalles completos con galería de fotos
- Información del publicador
- Historial de reseñas

## 🛠️ Tecnologías

### **Frontend**
- **Flutter 3.32.8**: Framework de desarrollo móvil
- **Dart**: Lenguaje de programación
- **Material Design**: Sistema de diseño de Google

### **Backend**
- **Supabase Authentication**: Gestión de usuarios con JWT
- **PostgreSQL**: Base de datos relacional con Supabase
- **Supabase Storage**: Almacenamiento de archivos seguro
- **Row Level Security**: Protección de datos a nivel de fila
- **Real-time**: Actualizaciones en tiempo real

### **Gestión de Estado**
- **Provider**: Patrón de gestión de estado reactivo
- **ChangeNotifier**: Notificaciones de cambios de estado

### **Funcionalidades Adicionales**
- **Image Picker**: Selección de imágenes
- **Cached Network Image**: Caché de imágenes optimizado
- **UUID**: Generación de identificadores únicos
- **Intl**: Internacionalización y formatos

## � Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── user.dart            # Modelo de usuario
│   ├── tourist_site.dart    # Modelo de sitio turístico
│   └── review.dart          # Modelo de reseña
├── screens/                  # Pantallas de la aplicación
│   ├── auth/                # Autenticación
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home_screen.dart     # Pantalla principal
│   ├── sites/               # Gestión de sitios
│   │   ├── sites_list_screen.dart
│   │   ├── site_detail_screen.dart
│   │   └── add_site_screen.dart
│   └── profile_screen.dart  # Perfil de usuario
├── services/                 # Servicios de backend
│   ├── auth_service.dart    # Servicio de autenticación
│   ├── tourist_site_service.dart # Gestión de sitios
│   └── review_service.dart  # Gestión de reseñas
├── widgets/                  # Componentes reutilizables
│   ├── site_card.dart       # Tarjeta de sitio
│   ├── review_card.dart     # Tarjeta de reseña
│   └── image_picker_widget.dart # Selector de imágenes
└── utils/                    # Utilidades
    └── constants.dart        # Constantes de la aplicación
```

## 🚀 Instalación y Configuración

### **Prerrequisitos**
- Flutter SDK ≥3.0.0
- Dart SDK ≥3.0.0
- Android Studio / VS Code
- Cuenta de Firebase

### **Pasos de Instalación**

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/el-buho-turismo.git
   cd el-buho-turismo
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Supabase**
   - Crear proyecto en [Supabase](https://supabase.com/)
   - Ejecutar el SQL de `CONFIGURAR_SUPABASE.sql` en SQL Editor
   - Crear bucket `tourist-images` en Storage
   - Copiar URL y anon key a `lib/main.dart`

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

5. **Generar APK de producción**
   ```bash
   flutter build apk --release
   ```

## 📋 Funcionalidades Detalladas

### **Autenticación de Usuarios**
- Registro con validación de email
- Inicio de sesión seguro
- Recuperación de contraseña
- Cierre de sesión
- Persistencia de sesión

### **Gestión de Sitios Turísticos**
- Crear nuevos sitios con información completa
- Subir múltiples fotografías (máximo 5)
- Editar información de sitios propios
- Eliminar sitios si es necesario
- Categorización por tipo de sitio

### **Sistema de Reseñas y Calificaciones**
- Escribir reseñas detalladas
- Calificar con sistema de estrellas
- Ver historial de reseñas
- Responder como publicador
- Moderación de contenido inapropiado

### **Exploración y Búsqueda**
- Lista completa de sitios disponibles
- Filtros por categoría y calificación
- Búsqueda por nombre o descripción
- Ordenamiento por fecha o popularidad
- Vista detallada con galería completa

## 🎯 Casos de Uso

### **Para Turistas**
1. **Descubrir**: Encontrar sitios turísticos únicos y auténticos
2. **Planificar**: Leer reseñas antes de visitar
3. **Compartir**: Escribir experiencias para otros viajeros

### **Para Locales**
1. **Promover**: Dar a conocer lugares especiales de su ciudad
2. **Guiar**: Compartir conocimiento local auténtico
3. **Conectar**: Interactuar con visitantes interesados

### **Para Comunidad**
1. **Colaborar**: Construir una base de datos comunitaria
2. **Validar**: Sistema de reseñas para mantener calidad
3. **Crecer**: Expandir el turismo local responsable

## 🔒 Seguridad y Privacidad

- **Autenticación segura** con Supabase Auth y JWT
- **Row Level Security** para protección de datos
- **Validación de datos** en cliente y servidor
- **Permisos granulares** por tipo de usuario
- **Moderación de contenido** para mantener calidad
- **Protección de datos** según estándares internacionales

## 📈 Métricas y Análisis

- Seguimiento de sitios más visitados
- Análisis de reseñas y calificaciones
- Estadísticas de uso por tipo de usuario
- Métricas de engagement de la comunidad

## 🤝 Contribuir

Este proyecto está abierto a contribuciones de la comunidad. Para contribuir:

1. Fork el repositorio
2. Crear una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 👨‍💻 Desarrollado por

**El Búho Team** - Desarrolladores especializados en aplicaciones móviles y turismo digital.

---

### 🌟 ¡Descarga y empieza a explorar tu ciudad como nunca antes!

**APK Lista:** `build/app/outputs/flutter-apk/app-release.apk`
