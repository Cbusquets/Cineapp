import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['TMDB_BASE_URL'] ?? '';
  static String get imageUrl => dotenv.env['TMDB_IMAGE_URL'] ?? '';

  static String get trending => '/trending/movie/week';
  static String get search => '/search/movie';
  static String movieDetail(int id) => '/movie/$id';
}