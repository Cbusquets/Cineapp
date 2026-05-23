import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;
  SearchMovies(this.repository);

  Future<List<Movie>> call(String query, {int? genreId}) =>
      repository.searchMovies(query, genreId: genreId);
}