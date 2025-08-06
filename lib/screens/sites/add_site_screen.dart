import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service_supabase.dart';
import '../../services/tourist_site_service_supabase.dart';

class AddSiteScreen extends StatefulWidget {
  @override
  _AddSiteScreenState createState() => _AddSiteScreenState();
}

class _AddSiteScreenState extends State<AddSiteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final TouristSiteService _siteService = TouristSiteService();
  final ImagePicker _imagePicker = ImagePicker();
  
  List<File> _selectedImages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final totalImages = _selectedImages.length + images.length;
        if (totalImages > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Máximo 5 imágenes permitidas'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        setState(() {
          _selectedImages.addAll(images.map((xfile) => File(xfile.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imágenes: $e')),
      );
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        if (_selectedImages.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Máximo 5 imágenes permitidas'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar foto: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitSite() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debes agregar al menos una imagen'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser!;

      await _siteService.createSite(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _locationController.text.trim(),
        latitude: 0.0, // TODO: Implementar geolocalización
        longitude: 0.0, // TODO: Implementar geolocalización
        images: _selectedImages,
        userId: user.id,
      );

      // Limpiar formulario
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      setState(() {
        _selectedImages.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sitio turístico publicado exitosamente')),
      );

      // Ir a la pestaña de explorar
      DefaultTabController.of(context).animateTo(0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al publicar sitio: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicar Sitio'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo título
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título del sitio',
                  hintText: 'Ej: Plaza de Armas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  if (value.trim().length < 3) {
                    return 'El título debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Campo ubicación
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                  hintText: 'Ej: Centro Histórico, Lima',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la ubicación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Campo descripción
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Describe el sitio turístico...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  if (value.trim().length < 20) {
                    return 'La descripción debe tener al menos 20 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Sección de imágenes
              Text(
                'Imágenes (máximo 5)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),

              // Botones para agregar imágenes
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectedImages.length < 5 ? _pickImages : null,
                      icon: Icon(Icons.photo_library),
                      label: Text('Galería'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectedImages.length < 5 ? _takePicture : null,
                      icon: Icon(Icons.camera_alt),
                      label: Text('Cámara'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade100,
                        foregroundColor: Colors.green.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Vista previa de imágenes
              if (_selectedImages.isNotEmpty) ...[
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImages[index],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Información sobre imágenes
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Las imágenes serán redimensionadas automáticamente para optimizar el almacenamiento.',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Botón publicar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitSite,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Publicando...'),
                          ],
                        )
                      : Text(
                          'Publicar Sitio',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
