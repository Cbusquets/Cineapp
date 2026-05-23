import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrending();
  Future<List<Movie>> searchMovies(String query);
  Future<Movie> getMovieDetail(int movieId);
  Future<List<Movie>> getFavorites();
  Future<void> saveFavorite(Movie movie);
  Future<void> removeFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
}