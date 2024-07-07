import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'vObJ3fi8K7MS6M4onZ8sKKio0rizZrmc';
  final String baseUrl = 'https://api.giphy.com/v1/gifs';

  Future<List<dynamic>> fetchTrendingGifs(
      {int limit = 25, int offset = 0}) async {
    final url = '$baseUrl/trending?api_key=$apiKey&limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw ApiException('Failed to load trending GIFs');
    }
  }

  Future<List<dynamic>> searchGifs(String query,
      {int limit = 20, int offset = 0}) async {
    final url =
        '$baseUrl/search?api_key=$apiKey&q=$query&limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw ApiException('Failed to search GIFs');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
