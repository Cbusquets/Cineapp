import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetTrending {
  final MovieRepository repository;
  GetTrending(this.repository);

  Future<List<Movie>> call() => repository.getTrending();
}