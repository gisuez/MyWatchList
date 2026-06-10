import 'package:http/http.dart' as http;
import 'dart:convert';

// IMPORT MODELS
import '../models/movie.dart';
import '../models/series.dart';
import '../models/series_detail.dart';

class TmdbService {
  static const String tmdbApiKey = 'a76eb5433e8b2f6f9d1f15dfa7acbe02';

  static const String tmdbUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageUrl = 'https://image.tmdb.org/t/p/w500';

  static Future<List<dynamic>> searchAll(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse(
        '$tmdbUrl/search/multi?api_key=$tmdbApiKey&query=${Uri.encodeComponent(query)}&language=it-IT',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List results = data['results'];

      return results
          .map((item) {
            if (item['media_type'] == 'movie') {
              return Movie.fromJson(item);
            } else if (item['media_type'] == 'tv') {
              return Series.fromJson(item);
            }
            // gli altri tipi vengono scartati (tipo person)
            return null;
          })
          .where((element) => element != null)
          .toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  static Future<SeriesDetail> getSeriesDetails(int seriesId) async {
    final response = await http.get(
      Uri.parse('$tmdbUrl/tv/$seriesId?api_key=$tmdbApiKey&language=it-IT'),
    );

    if (response.statusCode == 200) {
      return SeriesDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load series details');
    }
  }
}
