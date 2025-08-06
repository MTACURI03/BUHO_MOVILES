import 'package:flutter/material.dart';
import '../../models/tourist_site.dart';
import '../../services/tourist_site_service_supabase.dart';
import '../../widgets/site_card.dart';
import 'site_detail_screen.dart';

class SitesListScreen extends StatelessWidget {
  final TouristSiteService _siteService = TouristSiteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sitios Turísticos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<TouristSite>>(
        future: _siteService.getSites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Error al cargar sitios',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger rebuild
                      (context as Element).markNeedsBuild();
                    },
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final sites = snapshot.data ?? [];

          if (sites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.explore_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay sitios turísticos',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sé el primero en publicar un sitio',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Trigger rebuild
              (context as Element).markNeedsBuild();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: sites.length,
              itemBuilder: (context, index) {
                final site = sites[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: SiteCard(
                    site: site,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SiteDetailScreen(site: site),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
