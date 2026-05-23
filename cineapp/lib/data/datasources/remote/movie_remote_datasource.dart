import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/movie_model.dart';
import '../../models/genre_model.dart';

abstract class MovieRemoteDatasource {
  Future<List<MovieModel>> getTrending();
  Future<List<MovieModel>> searchMovies(String query, {int? genreId});
  Future<List<MovieModel>> discoverByGenre(int genreId);
  Future<MovieModel> getMovieDetail(int movieId);
  Future<List<GenreModel>> getGenres();
  Future<List<Map<String, dynamic>>> getMovieVideos(int movieId);
}

class MovieRemoteDatasourceImpl implements MovieRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<MovieModel>> getTrending() async {
    final response = await _dio.get(ApiConstants.trending);
    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int? genreId}) async {
    final params = <String, dynamic>{'query': query};
    if (genreId != null) params['with_genres'] = genreId;
    final response = await _dio.get(ApiConstants.search, queryParameters: params);
    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<List<MovieModel>> discoverByGenre(int genreId) async {
    final response = await _dio.get(
      ApiConstants.discover,
      queryParameters: {'with_genres': genreId, 'sort_by': 'popularity.desc'},
    );
    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<MovieModel> getMovieDetail(int movieId) async {
    final response = await _dio.get(ApiConstants.movieDetail(movieId));
    return MovieModel.fromJson(response.data);
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await _dio.get(ApiConstants.genres);
    final results = response.data['genres'] as List;
    return results.map((e) => GenreModel.fromJson(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getMovieVideos(int movieId) async {
    final response = await _dio.get(ApiConstants.movieVideos(movieId));
    final results = response.data['results'] as List;
    return results.cast<Map<String, dynamic>>();
  }
}