import 'package:hive_flutter/hive_flutter.dart';
import '../../models/movie_model.dart';

abstract class MovieLocalDatasource {
  Future<void> saveFavorite(MovieModel movie);
  Future<void> removeFavorite(int movieId);
  Future<List<MovieModel>> getFavorites();
  Future<bool> isFavorite(int movieId);
}

class MovieLocalDatasourceImpl implements MovieLocalDatasource {
  Box<MovieModel> get _box => Hive.box<MovieModel>('favorites');

  @override
  Future<void> saveFavorite(MovieModel movie) async {
    await _box.put(movie.id, movie);
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    await _box.delete(movieId);
  }

  @override
  Future<List<MovieModel>> getFavorites() async {
    return _box.values.toList();
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    return _box.containsKey(movieId);
  }
}