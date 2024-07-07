import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giphy_app/networking/apiservices.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List _gifs = [];
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, bool> _favoritesMap = {};

  @override
  void initState() {
    super.initState();
    _fetchTrendingGifs();
  }

  Future<void> _fetchTrendingGifs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final gifs = await _apiService.fetchTrendingGifs();
      await _loadFavorites(gifs);
      setState(() {
        _gifs = gifs;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchGifs(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final gifs = await _apiService.searchGifs(query);
      await _loadFavorites(gifs);
      setState(() {
        _gifs = gifs;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavorites(List gifs) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesCollection = FirebaseFirestore.instance
          .collection('usersgpy')
          .doc(user.uid)
          .collection('favorites');

      final snapshot = await favoritesCollection.get();
      final favoriteUrls = snapshot.docs.map((doc) => doc['url']).toSet();

      setState(() {
        _favoritesMap = {
          for (var gif in gifs)
            gif['images']['fixed_height']['url']:
                favoriteUrls.contains(gif['images']['fixed_height']['url'])
        };
      });
    }
  }

  Future<void> _toggleFavorite(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesCollection = FirebaseFirestore.instance
          .collection('usersgpy')
          .doc(user.uid)
          .collection('favorites');

      if (_favoritesMap[url] == true) {
        final snapshot =
            await favoritesCollection.where('url', isEqualTo: url).get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      } else {
        await favoritesCollection.add({'url': url});
      }

      setState(() {
        _favoritesMap[url] = !_favoritesMap[url]!;
      });
    } else {
      setState(() {
        _errorMessage = 'Please log in to add to favorites.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search GIFs',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _searchGifs(_searchController.text);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: _gifs.length,
                      itemBuilder: (context, index) {
                        final gif = _gifs[index];
                        final gifUrl = gif['images']['fixed_height']['url'];
                        final isFavorite = _favoritesMap[gifUrl] ?? false;
                        return Stack(
                          children: [
                            Image.network(gifUrl),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () {
                                  _toggleFavorite(gifUrl);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
