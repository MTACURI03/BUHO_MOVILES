import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service_supabase.dart';
import '../sites/sites_list_screen.dart';
import '../sites/add_site_screen.dart';
import '../profile/profile_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    _screens = [
      SitesListScreen(),
      if (user?.isPublisher == true) AddSiteScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;

        if (user == null) {
          return LoginScreen();
        }

        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explorar',
              ),
              if (user.isPublisher)
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_location),
                  label: 'Publicar',
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }
}
