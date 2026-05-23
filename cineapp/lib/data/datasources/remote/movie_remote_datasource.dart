import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/movie_model.dart';

abstract class MovieRemoteDatasource {
  Future<List<MovieModel>> getTrending();
  Future<List<MovieModel>> searchMovies(String query);
  Future<MovieModel> getMovieDetail(int movieId);
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
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await _dio.get(
      ApiConstants.search,
      queryParameters: {'query': query},
    );
    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<MovieModel> getMovieDetail(int movieId) async {
    final response = await _dio.get(ApiConstants.movieDetail(movieId));
    return MovieModel.fromJson(response.data);
  }
}