<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Instrucciones para el Proyecto El Búho - Turismo

Este es un proyecto Flutter para una aplicación móvil de turismo ciudadano.

## Contexto del Proyecto
- **Empresa**: El Búho
- **Tipo**: Aplicación móvil de turismo
- **Framework**: Flutter
- **Backend**: Firebase (Auth, Firestore, Storage)

## Funcionalidades Principales
1. **Autenticación**: Registro e inicio de sesión
2. **Perfiles de Usuario**: Visitante y Publicador
3. **Publicaciones**: Sitios turísticos con hasta 5 fotos
4. **Reseñas**: Sistema de reseñas y respuestas
5. **Gestión de Imágenes**: Cámara y galería con validación de tamaño

## Reglas de Desarrollo
- Usar Material Design como base
- Implementar validaciones de entrada
- Manejar estados de carga y error
- Código limpio y comentado
- Responsive design para diferentes tamaños de pantalla

## Estructura de Archivos
- `models/`: Modelos de datos (User, TouristSite, Review)
- `screens/`: Pantallas de la aplicación
- `services/`: Servicios de Firebase y lógica de negocio
- `widgets/`: Componentes reutilizables
- `utils/`: Utilidades y constantes

## Consideraciones de Seguridad
- Validar permisos de usuario antes de operaciones
- Sanitizar inputs del usuario
- Manejar errores de red apropiadamente
