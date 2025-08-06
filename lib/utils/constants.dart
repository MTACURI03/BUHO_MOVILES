class AppConstants {
  // Información de la app
  static const String appName = 'El Búho Turismo';
  static const String appVersion = '1.0.0';
  
  // Límites de la aplicación
  static const int maxImagesPerSite = 5;
  static const int maxImageSizeMB = 5;
  static const int minReviewLength = 10;
  static const int minSiteTitleLength = 3;
  static const int minSiteDescriptionLength = 20;
  
  // Nombres de colecciones en Firestore
  static const String usersCollection = 'users';
  static const String sitesCollection = 'tourist_sites';
  static const String reviewsCollection = 'reviews';
  
  // Mensajes de error comunes
  static const String networkError = 'Error de conexión. Verifica tu internet.';
  static const String unknownError = 'Ha ocurrido un error inesperado.';
  static const String permissionDenied = 'No tienes permisos para esta acción.';
  
  // Rutas de Storage
  static const String siteImagesPath = 'tourist_sites';
  
  // Configuración de imágenes
  static const double maxImageWidth = 1920;
  static const double maxImageHeight = 1080;
  static const int imageQuality = 85;
}
