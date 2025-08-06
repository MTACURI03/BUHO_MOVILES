import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/tourist_site.dart';

class TouristSiteService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  Future<List<TouristSite>> getSites() async {
    try {
      final response = await _supabase
          .from('tourist_sites')
          .select()
          .order('created_at', ascending: false);

      return response
          .map<TouristSite>((data) => TouristSite.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting sites: $e');
      return [];
    }
  }

  Future<List<TouristSite>> getSitesByPublisher(String publisherId) async {
    try {
      final response = await _supabase
          .from('tourist_sites')
          .select()
          .eq('publisher_id', publisherId)
          .order('created_at', ascending: false);

      return response
          .map<TouristSite>((data) => TouristSite.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting sites by publisher: $e');
      return [];
    }
  }

  Future<TouristSite?> getSiteById(String siteId) async {
    try {
      final response = await _supabase
          .from('tourist_sites')
          .select()
          .eq('id', siteId)
          .single();

      return TouristSite.fromMap(response);
    } catch (e) {
      print('Error getting site by ID: $e');
      return null;
    }
  }

  Future<String?> createSite({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required String userId,
    required List<File> images,
  }) async {
    try {
      // Subir imágenes a Supabase Storage
      List<String> imageUrls = [];
      
      for (int i = 0; i < images.length; i++) {
        final imageId = _uuid.v4();
        final fileName = 'tourist_sites/$userId/$imageId.jpg';
        
        final response = await _supabase.storage
            .from('tourist-images')
            .upload(fileName, images[i]);

        if (response.isNotEmpty) {
          final imageUrl = _supabase.storage
              .from('tourist-images')
              .getPublicUrl(fileName);
          imageUrls.add(imageUrl);
        }
      }

      // Crear sitio en la base de datos
      final site = TouristSite(
        id: _uuid.v4(),
        title: title,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        userId: userId,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
      );

      await _supabase.from('tourist_sites').insert(site.toMap());
      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateSite({
    required String siteId,
    required String name,
    required String description,
    required String location,
    List<File>? newImages,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'name': name,
        'description': description,
        'location': location,
      };

      // Si hay nuevas imágenes, subirlas
      if (newImages != null && newImages.isNotEmpty) {
        // Obtener sitio actual para el publisherId
        final currentSite = await getSiteById(siteId);
        if (currentSite == null) return 'Sitio no encontrado';

        List<String> imageUrls = [];
        
        for (int i = 0; i < newImages.length; i++) {
          final imageId = _uuid.v4();
          final fileName = 'tourist_sites/${currentSite.userId}/$imageId.jpg';
          
          final response = await _supabase.storage
              .from('tourist-images')
              .upload(fileName, newImages[i]);

          if (response.isNotEmpty) {
            final imageUrl = _supabase.storage
                .from('tourist-images')
                .getPublicUrl(fileName);
            imageUrls.add(imageUrl);
          }
        }

        updateData['image_urls'] = imageUrls;
      }

      await _supabase
          .from('tourist_sites')
          .update(updateData)
          .eq('id', siteId);

      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteSite(String siteId) async {
    try {
      // Eliminar reseñas del sitio primero
      await _supabase
          .from('reviews')
          .delete()
          .eq('site_id', siteId);

      // Eliminar el sitio
      await _supabase
          .from('tourist_sites')
          .delete()
          .eq('id', siteId);

      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<TouristSite>> searchSites(String query) async {
    try {
      final response = await _supabase
          .from('tourist_sites')
          .select()
          .or('name.ilike.%$query%,description.ilike.%$query%,location.ilike.%$query%')
          .order('created_at', ascending: false);

      return response
          .map<TouristSite>((data) => TouristSite.fromMap(data))
          .toList();
    } catch (e) {
      print('Error searching sites: $e');
      return [];
    }
  }
}
