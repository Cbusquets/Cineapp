import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetFavorites {
  final MovieRepository repository;
  GetFavorites(this.repository);

  Future<List<Movie>> call() => repository.getFavorites();
}