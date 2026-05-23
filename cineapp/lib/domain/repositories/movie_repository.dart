import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrending();
  Future<List<Movie>> searchMovies(String query, {int? genreId});
  Future<List<Movie>> discoverByGenre(int genreId);
  Future<Movie> getMovieDetail(int movieId);
  Future<List<Movie>> getFavorites();
  Future<void> saveFavorite(Movie movie);
  Future<void> removeFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
  Future<Map<int, String>> getGenres();
  Future<String?> getTrailerUrl(int movieId);
}