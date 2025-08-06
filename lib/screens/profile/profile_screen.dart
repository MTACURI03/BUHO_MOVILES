import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service_supabase.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          final user = authService.currentUser;

          if (user == null) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Información del usuario
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: user.isPublisher 
                                ? Colors.green.shade100 
                                : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user.isPublisher ? 'Publicador' : 'Visitante',
                            style: TextStyle(
                              color: user.isPublisher 
                                  ? Colors.green.shade800 
                                  : Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Información sobre permisos
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Permisos de tu cuenta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        _buildPermissionItem(
                          icon: Icons.visibility,
                          title: 'Ver sitios turísticos',
                          description: 'Explorar todos los sitios publicados',
                          enabled: true,
                        ),
                        
                        _buildPermissionItem(
                          icon: Icons.rate_review,
                          title: 'Escribir reseñas',
                          description: 'Compartir opiniones sobre sitios',
                          enabled: true,
                        ),
                        
                        _buildPermissionItem(
                          icon: Icons.add_location,
                          title: 'Publicar sitios',
                          description: 'Agregar nuevos sitios turísticos',
                          enabled: user.isPublisher,
                        ),
                        
                        _buildPermissionItem(
                          icon: Icons.photo_camera,
                          title: 'Subir fotografías',
                          description: 'Agregar hasta 5 fotos por sitio',
                          enabled: user.isPublisher,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Estadísticas (si es publicador)
                if (user.isPublisher) ...[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mis estadísticas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                icon: Icons.location_on,
                                title: 'Sitios',
                                value: '0', // Aquí se podría agregar lógica para contar
                              ),
                              _buildStatItem(
                                icon: Icons.photo,
                                title: 'Fotos',
                                value: '0',
                              ),
                              _buildStatItem(
                                icon: Icons.favorite,
                                title: 'Me gusta',
                                value: '0',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],

                // Botón cerrar sesión
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context, authService),
                    icon: Icon(Icons.logout),
                    label: Text('Cerrar Sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Información de la app
                Text(
                  'El Búho - Turismo v1.0.0',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required bool enabled,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: enabled 
                  ? Colors.green.shade100 
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: enabled 
                  ? Colors.green.shade700 
                  : Colors.grey.shade500,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: enabled 
                        ? Colors.black 
                        : Colors.grey.shade600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled 
                ? Colors.green 
                : Colors.grey.shade400,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade700,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authService.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
