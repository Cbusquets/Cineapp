import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class ToggleFavorite {
  final MovieRepository repository;
  ToggleFavorite(this.repository);

  Future<void> call(Movie movie, bool isFavorite) async {
    if (isFavorite) {
      await repository.removeFavorite(movie.id);
    } else {
      await repository.saveFavorite(movie);
    }
  }
}