import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/local/movie_local_datasource.dart';
import '../datasources/remote/movie_remote_datasource.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDatasource remoteDatasource;
  final MovieLocalDatasource localDatasource;

  MovieRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<Movie>> getTrending() async {
    final movies = await remoteDatasource.getTrending();
    return movies.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final movies = await remoteDatasource.searchMovies(query);
    return movies.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Movie> getMovieDetail(int movieId) async {
    final movie = await remoteDatasource.getMovieDetail(movieId);
    return movie.toEntity();
  }

  @override
  Future<List<Movie>> getFavorites() async {
    final movies = await localDatasource.getFavorites();
    return movies.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> saveFavorite(Movie movie) async {
    await localDatasource.saveFavorite(MovieModel.fromEntity(movie));
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    await localDatasource.removeFavorite(movieId);
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    return localDatasource.isFavorite(movieId);
  }
}