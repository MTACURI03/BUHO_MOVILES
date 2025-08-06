import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../models/tourist_site.dart';
import '../../models/review.dart';
import '../../services/review_service_supabase.dart';
import '../../widgets/review_card.dart';
import '../../widgets/add_review_dialog.dart';

class SiteDetailScreen extends StatefulWidget {
  final TouristSite site;

  const SiteDetailScreen({Key? key, required this.site}) : super(key: key);

  @override
  _SiteDetailScreenState createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends State<SiteDetailScreen> {
  final ReviewService _reviewService = ReviewService();
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.site.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galería de imágenes
            _buildImageGallery(),
            
            // Información del sitio
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.site.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, 
                           color: Colors.grey.shade600, size: 20),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.site.address,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.site.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey.shade600),
                      SizedBox(width: 8),
                      Text(
                        'Publicado por usuario',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Spacer(),
                      Text(
                        DateFormat('dd/MM/yyyy').format(widget.site.createdAt),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Divider(),
            
            // Sección de reseñas
            _buildReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    if (widget.site.imageUrls.isEmpty) {
      return Container(
        height: 250,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.landscape, size: 64, color: Colors.grey),
            SizedBox(height: 8),
            Text('Sin imágenes', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Container(
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: widget.site.imageUrls.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.site.imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                        Text('Error al cargar imagen'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Indicador de páginas
          if (widget.site.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.site.imageUrls.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          
          // Contador de imágenes
          if (widget.site.imageUrls.length > 1)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${widget.site.imageUrls.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reseñas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddReviewDialog(),
                icon: Icon(Icons.rate_review, size: 18),
                label: Text('Escribir reseña'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          FutureBuilder<List<Review>>(
            future: _reviewService.getReviews(widget.site.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error al cargar reseñas'),
                );
              }

              final reviews = snapshot.data ?? [];

              if (reviews.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(Icons.rate_review_outlined, 
                             size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Sin reseñas aún',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sé el primero en escribir una reseña',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: reviews.map((review) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: ReviewCard(review: review),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(siteId: widget.site.id),
    );
  }
}
