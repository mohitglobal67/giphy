import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giphy_app/utils/routes/routes_name.dart';

class FavoritesScreen extends StatelessWidget {
  Future<void> _removeFromFavorites(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesCollection = FirebaseFirestore.instance
          .collection('usersgpy')
          .doc(user.uid)
          .collection('favorites');

      await favoritesCollection.doc(docId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please log in to view favorites.'));
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.home,
                (routes) => false,
              );
            },
          ),
          title: const Text('Favorites')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('usersgpy')
            .doc(user.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }

          final favorites = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return Stack(
                children: [
                  Image.network(favorite['url']),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.favorite),
                      color: Colors.red,
                      onPressed: () {
                        _removeFromFavorites(favorite.id);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
