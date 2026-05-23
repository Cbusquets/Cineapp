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
  Future<List<Movie>> searchMovies(String query, {int? genreId}) async {
    final movies = await remoteDatasource.searchMovies(query, genreId: genreId);
    return movies.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Movie>> discoverByGenre(int genreId) async {
    final movies = await remoteDatasource.discoverByGenre(genreId);
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

  @override
  Future<Map<int, String>> getGenres() async {
    final genres = await remoteDatasource.getGenres();
    return {for (var g in genres) g.id: g.name};
  }

  @override
  Future<String?> getTrailerUrl(int movieId) async {
    final videos = await remoteDatasource.getMovieVideos(movieId);
    final trailer = videos.firstWhere(
      (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
      orElse: () => {},
    );
    if (trailer.isEmpty) return null;
    return 'https://www.youtube.com/watch?v=${trailer['key']}';
  }
}