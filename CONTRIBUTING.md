# Contributing to El Búho - Turismo

¡Gracias por tu interés en contribuir a El Búho! 🦉

## 🚀 Formas de Contribuir

### 🐛 Reportar Bugs
- Usa los GitHub Issues para reportar problemas
- Incluye pasos para reproducir el error
- Menciona la versión de Flutter y dispositivo usado

### ✨ Solicitar Features
- Abre un Issue describiendo la funcionalidad deseada
- Explica por qué sería útil para los usuarios
- Si es posible, incluye mockups o diseños

### 🔧 Enviar Pull Requests
1. Fork el repositorio
2. Crea una rama descriptiva: `git checkout -b feature/nueva-funcionalidad`
3. Realiza tus cambios
4. Escribe tests si es apropiado
5. Ejecuta `flutter analyze` para verificar el código
6. Commit con mensajes descriptivos
7. Push a tu fork: `git push origin feature/nueva-funcionalidad`
8. Abre un Pull Request

## 📋 Estándares de Código

### Formato
```bash
# Formatear código antes de commit
flutter format .
```

### Análisis
```bash
# Verificar análisis de código
flutter analyze
```

### Convenciones de Naming
- **Archivos**: snake_case (`user_service.dart`)
- **Clases**: PascalCase (`UserService`)
- **Variables/Funciones**: camelCase (`getUserData`)
- **Constantes**: UPPER_SNAKE_CASE (`API_BASE_URL`)

### Estructura de Commits
```
tipo(ámbito): descripción corta

Descripción más detallada si es necesario

- Cambio específico 1
- Cambio específico 2

Closes #123
```

Tipos de commit:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de error
- `docs`: Documentación
- `style`: Formateo/estilo
- `refactor`: Refactorización
- `test`: Tests
- `chore`: Tareas de mantenimiento

## 🧪 Testing

### Ejecutar Tests
```bash
flutter test
```

### Escribir Tests
- Tests unitarios para lógica de negocio
- Tests de widgets para UI
- Tests de integración para flujos completos

## 📱 Desarrollo Local

### Setup
```bash
# Clonar tu fork
git clone https://github.com/tu-usuario/el-buho-turismo.git
cd el-buho-turismo

# Instalar dependencias
flutter pub get

# Ejecutar en desarrollo
flutter run
```

### Estructura de Ramas
- `main`: Código estable en producción
- `develop`: Desarrollo activo
- `feature/*`: Nuevas funcionalidades
- `bugfix/*`: Correcciones de errores
- `hotfix/*`: Correcciones críticas

## 🔍 Review Process

### Criterios de Aceptación
- [ ] Código sigue las convenciones del proyecto
- [ ] Tests incluidos y pasando
- [ ] Documentación actualizada si es necesario
- [ ] No rompe funcionalidad existente
- [ ] Performance adecuada
- [ ] Diseño consistent con Material Design

### Timeline
- Review inicial: 1-3 días
- Feedback y iteraciones: según complejidad
- Merge: después de aprobación de maintainers

## 🎯 Áreas de Contribución

### 🔥 High Priority
- Optimización de performance
- Mejoras en UX/UI
- Tests automatizados
- Documentación

### 🚀 Features Deseadas
- Sistema de favoritos
- Notificaciones push
- Modo offline
- Filtros avanzados de búsqueda
- Integración con mapas
- Sistema de badges/logros

### 🐛 Bugs Conocidos
- Ver GitHub Issues con label `bug`

## 💬 Comunicación

### Canales
- **GitHub Issues**: Para bugs y features
- **GitHub Discussions**: Para preguntas generales
- **Pull Requests**: Para revisiones de código

### Código de Conducta
- Sé respetuoso y constructivo
- Usa un lenguaje inclusivo
- Ayuda a otros contribuidores
- Mantén las discusiones enfocadas al tema

## 🏆 Reconocimientos

Los contribuidores serán reconocidos en:
- README.md
- Release notes
- Página de créditos en la app

## 📞 Contacto

¿Preguntas sobre el desarrollo?
- Abre un Issue
- Inicia una Discussion
- Contacta a los maintainers

---

¡Gracias por hacer de El Búho una mejor aplicación para la comunidad turística! 🦉✨
