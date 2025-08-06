import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/tourist_site.dart';

class SiteCard extends StatelessWidget {
  final TouristSite site;
  final VoidCallback? onTap;

  const SiteCard({
    Key? key,
    required this.site,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 200,
                width: double.infinity,
                child: site.imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: site.imageUrls.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, 
                                   size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Error al cargar imagen',
                                   style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.landscape, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Sin imagen',
                                 style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
              ),
            ),
            
            // Contenido
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, 
                           size: 16, color: Colors.grey.shade600),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          site.address,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    site.description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Información del publicador
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Publicado por usuario',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Fecha
                      Text(
                        DateFormat('dd/MM/yy').format(site.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  
                  // Indicador de múltiples imágenes
                  if (site.imageUrls.length > 1) ...[
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.photo_library, 
                             size: 16, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          '${site.imageUrls.length} fotos',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
