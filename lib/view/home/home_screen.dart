import 'package:flutter/material.dart';
import 'package:giphy_app/config/color/color.dart';
import 'package:giphy_app/provider/auth_provider.dart';
import 'package:giphy_app/utils/routes/routes_name.dart';
import 'package:giphy_app/view/favorites/favorites_screen.dart';
import 'package:giphy_app/view/search/search_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giphy App'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: AppColors.blackColor,
            ),
            onPressed: () async {
              await context.read<AuthService>().signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.login,
                (routes) => false,
              );
            },
          ),
        ],
      ),
      body: SearchScreen(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('Trending'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
